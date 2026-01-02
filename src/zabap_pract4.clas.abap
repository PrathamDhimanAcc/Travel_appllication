CLASS zabap_pract4 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zabap_pract4 IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.

*        TYPES : BEGIN OF wears,
*                curr type /dmo/currency_code,
*                END OF wears,
*            BEGIN OF ty_api_response,
*                result type string,
*                base_case type string,
*                conversion_rates type ref to data,
*            END OF ty_api_response.
*
*
*        DATA lv_response TYPE ty_api_response.
*
*
*        DATA it_currency TYPE STANDARD TABLE OF wears.
*
*        SELECT DISTINCT currency_code  FROM /dmo/carrier ORDER BY currency_code
*        INTO TABLE @it_currency.
*
**        DATA flag type abap_boolean .
**
**        flag = abap_false.
*        DATA it_rates TYPE STANDARD TABLE OF zcurre_rates.
*
*        IF sy-subrc = 0.
*            IF it_currency IS NOT INITIAL.
*                LOOP AT it_currency ASSIGNING FIELD-SYMBOL(<wa_currency>).
*
*                    LOOP AT it_currency ASSIGNING FIELD-SYMBOL(<wa_currency_2>).
*                        IF <wa_currency>-curr <> <wa_currency_2>-curr.
*                            DATA(base_url) = |https://v6.exchangerate-api.com/v6/bfae081ea95bee1f63e97741/latest/{ <wa_currency>-curr }|.
*                            out->write( base_url ).
*
*                            TRY.
*
*                            DATA(lo_destination) = cl_http_destination_provider=>create_by_url( base_url ).
*
*                            DATA(http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination  ).
*
*                            DATA(response) = http_client->execute( if_web_http_client=>get )->get_text( ).
*
*                            out->write( response ).
*
*                            DATA lr_json TYPE REF TO data.
*
*                            /ui2/cl_json=>deserialize(
*                                EXPORTING
*                                    json = response
*                                CHANGING
*                                    data = lr_json
*                              ).
*
*                              FIELD-SYMBOLS :
*                                <fs_rates> TYPE any,
*                                <fs_rate> TYPE any,
*                                <fs_root> TYPE any.
*
*                                ASSIGN lr_json->* TO <fs_root>.
**                                ASSIGN lv_response-conversion_rates->* TO <fs_rates>.
*
*                               ASSIGN COMPONENT 'conversion_rates' OF STRUCTURE <fs_root> TO <fs_rates>.
*
*                                IF <fs_rates> IS ASSIGNED.
*
*                                    ASSIGN COMPONENT <wa_currency_2>-curr
*                                    OF STRUCTURE <fs_rates> TO <fs_rate>.
*
*                                    IF <fs_rate> IS ASSIGNED.
*                                        DATA(lv_rate_string) = CONV string( <fs_rate>->* ).
*
*                                        out->write( lv_rate_string ).
*
*
*                                        APPEND VALUE zcurre_rates(
*                                            client = '100'
*                                            from_curr = <wa_currency>-curr
*                                            to_curr = <wa_currency_2>-curr
*                                            valid_from = cl_abap_context_info=>get_system_date(  )
*                                            rate = <fs_rate>->*
*                                          ) TO  it_rates.
**                                        INSERT zcurre_rates FROM TABLE @(
**                                            VALUE #(
**                                                   ( client = '100' from_curr = <wa_currency> to_curr = <wa_currency_2> valid_from = cl_abap_context_info=>get_system_date(  ) rate = <fs_rate> )
**                                              )
**                                         ).
*
*                                        out->write( |From { <wa_currency>-curr } To { <wa_currency_2>-curr } Rate { <fs_rate>->* } | ).
*                                    ENDIF.
*
*                                ENDIF.
*
*
*                            out->write( response ).
**                            flag = abap_true.
**                            exit.
*
*                            CATCH CX_WEB_HTTP_CLIENT_ERROR INTO DATA(client_error).
*                                    out->write( client_error ).
*                            ENDTRY.
*
*                        ENDIF.
*                    ENDLOOP.
**                    IF flag = abap_true.
**                        EXIT.
**                    ENDIF.
*                ENDLOOP.
*            ENDIF.
*        ENDIF.
*        IF it_rates IS NOT INITIAL.
*            INSERT zcurre_rates FROM TABLE @it_rates.
*            COMMIT ENTITIES.
*        ENDIF.
    ENDMETHOD.
ENDCLASS.
