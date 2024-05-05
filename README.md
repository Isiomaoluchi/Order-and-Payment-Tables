# Order-and-Payment-Tables
## Project Overview
This dataset focuses on the order and payment transactions of a company that deals with the sale of goods. The goal is to identify customers who have received their products through delivery, invoicing, shipping, and other methods.

## Data Source
This dataset was obtained from Kaggle.

## Tools
Excel spreadsheet and SQL

## Data cleaning
The data was not dirty, so it required no cleaning for the answers I was trying to achieve.

## Data Analysis
1. orders that were cancelled but also delivered.
2. orders that were approved but never got to the customer.
3. Orders that were canclled, the courier got it but it was never delivered.
4. Orders that were paid for twice... etc
   
## Finding and Result
1. 46 orders were cancelled but still got delivered.
2. 1 order was approved and never got to the customer.
3. 4 orders weren't delivered despite being canceled; the courier received them.
4. 129 orders were paid for twice
   
## Recommendation
1. Estimated delivery dates should be provided once payment is about to be made and not when the item is added to the cart.
2. Additionally, some items were not delivered even after payment was made, indicating a need for the company to review its courier services.
3. Similarly, some items were cancelled, highlighting the importance of reviewing the courier service to address these issues.
