resource "aws_glue_catalog_database" "processed" {
  name = var.database_name
  description = "Process parquet tables for brazillian ecommerce dataset"

  parameters = {
    project = "brazillian-ecommerce"
    environment = "dev"
    data_zone = "processed"
    file_format = "parquet"
  }
}

resource "aws_glue_catalog_table" "customers" {
  name = "customers"
  database_name = aws_glue_catalog_database.processed.name
  table_type = "EXTERNAL"

  parameters = {
    EXTERNAL = "TRUE"
    classification = "parquet"
    compresstype = "snappy"
  }

  storage_descriptor {
    location = "s3://${var.data_lake_bucket_name}/processed/customers/"

    input_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"

    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name = "customer-parquet-serde"

      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

        columns {
      name = "customer_id"
      type = "string"
    }

    columns {
      name = "customer_unique_id"
      type = "string"
    }

    columns {
      name = "customer_zip_code_prefix"
      type = "string"
    }

    columns {
      name = "customer_city"
      type = "string"
    }

    columns {
      name = "customer_state"
      type = "string"
    }

    columns {
      name = "processed_at"
      type = "timestamp"
    }
  }
}