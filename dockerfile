FROM jupyter/pyspark-notebook

USER root

# Azure Storage provider for Spark 
ENV HADOOP_SEMVER $HADOOP_VERSION.0

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends software-properties-common && \
    apt-add-repository universe && \
    apt-get install -y --no-install-recommends  maven && \
    echo "<project>" \
                    "<modelVersion>4.0.0</modelVersion>" \
                    "<groupId>groupId</groupId>" \
                    "<artifactId>artifactId</artifactId>" \
                    "<version>1.0</version>" \
                "<dependencies>" \
                    "<dependency>" \
                        "<groupId>org.apache.hadoop</groupId>" \
                        "<artifactId>hadoop-azure</artifactId>" \
                        "<version>${HADOOP_SEMVER}</version>" \
                    "<exclusions>" \
                        "<exclusion>" \
                            "<groupId>org.apache.hadoop</groupId>" \
                            "<artifactId>hadoop-common</artifactId>" \
                        "</exclusion>" \
                        "<exclusion>" \
                            "<groupId>com.fasterxml.jackson.core</groupId>" \
                            "<artifactId>jackson-core</artifactId>" \
                        "</exclusion>" \
                    "</exclusions> " \
                    "</dependency>" \
                    "<dependency>" \
                        "<groupId>com.microsoft.sqlserver</groupId>" \
                        "<artifactId>mssql-jdbc</artifactId>" \
                        "<version>6.4.0.jre8</version>" \
                    "</dependency>" \
                    "<dependency>" \
                        "<groupId>com.microsoft.azure</groupId>" \
                        "<artifactId>azure-storage</artifactId>" \
                        "<version>2.2.0</version>" \
                        "<exclusions>" \
                            "<exclusion>" \
                                "<groupId>com.fasterxml.jackson.core</groupId>" \
                                "<artifactId>jackson-core</artifactId>" \
                            "</exclusion>" \
                            "<exclusion>" \
                                "<groupId>org.apache.commons</groupId>" \
                                "<artifactId>commons-lang3</artifactId>" \
                            "</exclusion>" \
                            "<exclusion>" \
                                "<groupId>org.slf4j</groupId>" \
                                "<artifactId>slf4j-api</artifactId>" \
                            "</exclusion>" \
                        "</exclusions>" \
                    "</dependency>" \
                    "<dependency>" \
                        "<groupId>com.microsoft.azure</groupId>" \
                        "<artifactId>azure-cosmosdb-spark_2.2.0_2.11</artifactId>" \
                        "<version>1.1.1</version>" \
                        "<exclusions>" \
                            "<exclusion>" \
                                "<groupId>org.apache.tinkerpop</groupId>" \
                                "<artifactId>tinkergraph-gremlin</artifactId>" \
                            "</exclusion>" \
                            "<exclusion>" \
                                "<groupId>org.apache.tinkerpop</groupId>" \
                                "<artifactId>spark-gremlin</artifactId>" \
                            "</exclusion>" \
                            "<exclusion>" \
                                "<groupId>io.netty</groupId>" \
                                "<artifactId>*</artifactId>" \
                            "</exclusion>" \
                            "<exclusion>" \
                                "<groupId>com.fasterxml.jackson.core</groupId>" \
                                "<artifactId>jackson-annotations</artifactId>" \
                            "</exclusion>" \
                        "</exclusions> " \
                    "</dependency>" \
                "</dependencies>" \
            "</project>" > /tmp/pom.xml \
    && cd /tmp \
    && mvn dependency:copy-dependencies -DoutputDirectory="${SPARK_HOME}/jars/" \
    && apt-get --purge autoremove -y maven \
    && rm -rf /tmp/*  

USER $NB_UID

RUN pip install --upgrade pip
RUN pip install --upgrade --ignore-installed setuptools
RUN pip install --no-cache-dir \
    py4j==0.10.6 \
    spark-magic==0.5.0