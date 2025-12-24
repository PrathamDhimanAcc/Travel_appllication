CLASS zcl_data_gen_curr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_data_gen_curr IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.
        INSERT zcurre_rates FROM TABLE @(
            VALUE #(
                ( client = '100' from_curr = 'EUR' to_curr = 'USD' valid_from = cl_abap_context_info=>get_system_date( ) rate = '1.10000' )
                ( client = '100' from_curr = 'INR' to_curr = 'USD' valid_from = cl_abap_context_info=>get_system_date( ) rate = '0.011' )
                ( client = '100' from_curr = 'USD' to_curr = 'INR' valid_from = cl_abap_context_info=>get_system_date( ) rate = '89.79' )
              )

         ).

         out->write( | Inserted { sy-dbcnt } rows| ).

    ENDMETHOD.
ENDCLASS.
