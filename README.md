# Building A Data Warehouse on Microsoft Azure
This project designs and builds a **Data Warehouse** for the public bike sharing data of [Divvy Bikes](https://divvybikes.com/). The data is anonymized, and thus rider and payment data are augmented.
The project starts by designing a **Star Schema** that facilitates the following business analytics requirements:

- Analyze how much time is spent per ride
    * Based on date and time factors such as day of week and time of day.
    * Based on which station is the starting and / or ending station.
    * Based on age of the rider at time of the ride.
    * Based on whether the rider is a member or a casual rider.

 <br>

- Analyze how much money is spent.
    * Per month, quarter, year.
    * Per member, based on the age of the rider at account start.


 
The project then proceeds by creating an Extract-Load-Transform (ELT) pipeline to move the date from its Relational Model to the Star Schema.

The project utilizes multiple **Microsoft Azure** services, include:
* **Azure Database for PostgreSQL.**
* **Azure Data Lake Storage Gen 2.**
* **Azure Synapse Analytics.**
