# Main data file for healthyR

A dataset containing many common items found in an administrative
dataset at a hospital.

## Usage

``` r
data(healthyR_data)
```

## Format

A data frame with 187,721 rows and 17 variables

## Details

- mrn. Medical Record Number. Unique patient identifier.

- visit_id. Unique hospital Visit ID. Tied to an mrn

- visit_start_date_time. The starting datetime of a visit_id

- visit_end_date_time. The ending datetime of a visit_id

- total_charge_amount. The total charge in dollars for a visit_id

- total_amount_due. The toal amount of money still due to a visit_id

- total_adjustment_amount. The toal amount of money adjusted off of an
  account for various reasons

- payer_grouping. The insurance classification of a visit_id

- total_payment_amount. The total amount of money paid on a visit_id

- ip_op_flag. A flag that indicates if the patient was admitted or was
  an outpatient

- service_line. The hospital service line for the visit_id

- length_of_stay. The total days a visit_id was admitted to the hospital

- expected_length_of_stay. The total days a visit_id was expected to be
  admitted

- lnmgth_of_stay_threshold. The threshold of the length_of_stay variable
  before the visit_id is considered to be an outlier

- los_outler_flag. A binary indicator of whether or not a visit_id was
  above the threshold

- readmit_flag. A binary indicator of whether or not a visit_id was
  admitted in 30 days

- readmit_expectation. The readmit rate for the particular visit
  computed from a benchmark
