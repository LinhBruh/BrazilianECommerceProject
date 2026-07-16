import sys

from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.utils import getResolvedOptions

from pyspark.context import SparkContext
from pyspark.sql.functions import (
    col,
    current_timestamp,
    lower,
    trim,
    upper,
)
from pyspark.sql.types import (
    StringType,
    StructField,
    StructType,
)


args = getResolvedOptions(
    sys.argv,
    [
        "JOB_NAME",
        "BUCKET_NAME",
    ],
)

sc = SparkContext()
glue_context = GlueContext(sc)
spark = glue_context.spark_session

job = Job(glue_context)
job.init(args["JOB_NAME"], args)

bucket_name = args["BUCKET_NAME"]

input_path = f"s3://{bucket_name}/raw/customers/"
output_path = f"s3://{bucket_name}/processed/customers/"

customers_schema = StructType(
    [
        StructField("customer_id", StringType(), True),
        StructField("customer_unique_id", StringType(), True),
        StructField("customer_zip_code_prefix", StringType(), True),
        StructField("customer_city", StringType(), True),
        StructField("customer_state", StringType(), True),
    ]
)

raw_df = (
    spark.read
    .option("header", "true")
    .option("quote", '"')
    .option("escape", '"')
    .schema(customers_schema)
    .csv(input_path)
) 

processed_df = raw_df.select(
    trim(col("customer_id")).alias("customer_id"),
    trim(col("customer_unique_id")).alias("customer_unique_id"),
    trim(col("customer_zip_code_prefix")).alias(
        "customer_zip_code_prefix"
    ),
    lower(trim(col("customer_city"))).alias("customer_city"),
    upper(trim(col("customer_state"))).alias("customer_state"),
)

invalid_key_count = (
    processed_df.filter(
        col("customer_id").isNull() | col("customer_unique_id").isNull()
    ).count()
)


if invalid_key_count > 0:
    raise ValueError(
        f"Found {invalid_key_count} rows with invalid customer keys"
    )

processed_df = processed_df.dropDuplicates(["customer_id"])
processed_df = processed_df.withColumn(
    "processed_at",
    current_timestamp(),
)

(
    processed_df
    .coalesce(1)
    .write
    .mode("overwrite")
    .option("compression", "snappy")
    .parquet(output_path)
)

job.commit()