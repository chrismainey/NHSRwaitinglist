# Generator of NHS patients

Generates simulated NHS patients

## Usage

``` r
sim_patients(n_rows = 10, start_date = NULL)
```

## Arguments

- n_rows:

  Number of rows/patients to generate

- start_date:

  Start date (needed to generate patient ages)

## Value

A data.frame representing an empty waiting list with the following
columns:

- Referral:

  Date. Referral date; all values are `NA`.

- Removal:

  Date. Removal date; all values are `NA`.

- Withdrawal:

  Date. Patient withdrawal date; all values are `NA`

- Priority:

  Numeric. Waiting list priority level, from 1 (most urgent) to 4 (least
  urgent).

- Target_wait:

  Numeric. Target number of days the patient should wait at the assigned
  priority level (e.g., 28 days for priority 2)

- Name:

  Character. Patient name in the format `"Last, First"`.

- Birth_date:

  Date. Date of birth.

- NHS_number:

  Integer. Patient identifier, up to 100,000,000.

- Specialty_code:

  Character. One-letter code representing the specialty of the
  procedure.

- Specialty:

  Character. Full name of the specialty associated with the procedure.

- OPCS:

  Character. OPCS-4 code of the selected procedure.

- Procedure:

  Character. Name of the selected procedure.

- Consultant:

  Character. Consultant name in the format `"Last, First"`.

## Examples

``` r
sim_patients()
#>    Referral Removal Withdrawal Priority Target_wait               Name
#> 1      <NA>    <NA>       <NA>        2          28      Holland, Niya
#> 2      <NA>    <NA>       <NA>        3          84 el-Jafri, Sahheeda
#> 3      <NA>    <NA>       <NA>        2          28     Montoya, Edwin
#> 4      <NA>    <NA>       <NA>        1           7   Peiffer, Kristen
#> 5      <NA>    <NA>       <NA>        2          28    Wheeler, Ka Ron
#> 6      <NA>    <NA>       <NA>        4         365       Wesley, Karl
#> 7      <NA>    <NA>       <NA>        4         365     Duwaldt, Corin
#> 8      <NA>    <NA>       <NA>        3          84      Dwyer, Lakota
#> 9      <NA>    <NA>       <NA>        2          28      Reece, Jordan
#> 10     <NA>    <NA>       <NA>        2          28   Cunnigan, Xavier
#>    Birth_date NHS_number Specialty_code
#> 1  2000-02-24   77560053              Z
#> 2  1995-08-22   19551478              Z
#> 3  1957-12-24   94383173              O
#> 4  2024-05-26    2538666              L
#> 5  2005-02-26   76510082              H
#> 6  1978-07-16   36311289              H
#> 7  1998-06-03   72529884              Z
#> 8  2025-09-15   86506985              E
#> 9  1944-05-29   65128374              B
#> 10 1994-03-23   36904721              A
#>                                          Specialty OPCS
#> 1  Subsidiary Classification of Sites of Operation Z792
#> 2  Subsidiary Classification of Sites of Operation Z814
#> 3                                   Overflow codes O122
#> 4                               Arteries and Veins L622
#> 5                           Lower Digestive System H519
#> 6                           Lower Digestive System H084
#> 7  Subsidiary Classification of Sites of Operation Z948
#> 8                                Respiratory Tract E078
#> 9                      Endocrine System and Breast B312
#> 10                                  Nervous System A346
#>                                                 Procedure
#> 1                                         Z79.2 Os calcis
#> 2                                    Z81.4 Shoulder joint
#> 3                                  O12.2 Maxillary artery
#> 4                L62.2 Open embolectomy of femoral artery
#> 5               H51.9 Unspecified excision of haemorrhoid
#> 6            H08.4 Transverse colectomy and ileostomy HFQ
#> 7                          Z94.8 Specified laterality NEC
#> 8  E07.8 Other specified other plastic operations on nose
#> 9                          B31.2 Augmentation mammoplasty
#> 10       A34.6 Exploration of glossopharyngeal nerve (ix)
#>                 Consultant
#> 1        Herrera, Samantha
#> 2             Lee, Killian
#> 3        Hernandez, Camilo
#> 4      Passantino, Brenden
#> 5         Nguyen, Crissela
#> 6              Zheng, Tina
#> 7          Reed, Gabrielle
#> 8  Escobedo Rangel, Selina
#> 9         el-Mir, Ghazaala
#> 10           Ortiz, Draven
```
