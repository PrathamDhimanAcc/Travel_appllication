CLASS zabap_pract DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zabap_pract IMPLEMENTATION.

    METHOD if_oo_adt_classrun~main.
        out->write( 'Hello world' ).
*        DATA var1 TYPE string.
*       var1 = 'Pratham'.
*        DATA(total) = ( 20 + 30 ).
*        DATA(total2) = ipow( base = total  exp = 3 ).
*        out->write( |Total before: { total }| ).
*       out->write( |Total after: { total2 }| ).
*
*        DATA the_date type d VALUE '20201116'.
*
*        out->write( |{ the_date }| ).
*        out->write( |{ the_date DATE = ISO }| ).
*        out->write( |{ the_date DATE = USER }| ).

*        DATA the_time type t VALUE '153045'.

*        out->write( |{ the_date DATE = USER } { the_time TIME = USER }| ).
*        DATA(age) = 80.
*        IF age <= 18.
*            out->write( |You are so cool| ).
*        ElSEIF age <= 50.
*            out->write( |You are not good| ).
*        ELSE.
*            out->write( |Out of league| ).
*        EnDIF.
*          DATA number TYPE i value 2000.
*
*          DATA IT_DATA TYPE TABLE OF i.
*
*          APPEND 78 to IT_DATA.
*          APPEND 78 to IT_DATA.
*          APPEND 8999 to IT_DATA.
*          APPEND 899 to IT_DATA.
*
*          LOOP AT IT_DATA INTO DATA(WA).
*            out->write( |{ WA }| ).
*          ENDLOOP.
*
*          out->write( |{ IT_DATA[ 3 ] }| ).

*        CONSTANTS max_count type i VALUE 20.
*
*        DATA numbers TYPE TABLE OF i.
*
*        DO max_count TimES.
*            CASE sy-index.
*                WHEN 1.
*                    APPEND 0 to numbers.
*                WHEN 2.
*                    APPEND 1 to numbers.
*                WHEN OTHERS.
*                    APPEND numbers[ sy-index - 1 ] + numbers[ sy-index - 2 ] to numbers.
*             ENDCASE.
*        ENDDO.
*
*        DATA output type table of string.
*
*        DATA(counter) = 0.
*
*        LOOP at numbers into DATA(number).
*               counter = counter + 1.
*               APPEND |{ counter WIDTH = 4 } :  { number WIDTH = 10 ALIGN = RIGHT }| to output.
*        ENDLOOP.
*
*
*        out->write( DATA = output
*                    name = | The first { max_count } fibonacci Numbers| ).



          data conn type ref to LOCAL_PRACT1.

          data conns type table of ref to LOCAL_PRACT1.

*          conn = new #(  ).
*
*          conn->carrier_id = 'LH'.
*
*          conn->connection_id = '04040'.
*
*          append conn to conns.
*
*          conn = new #(  ).
*
*          conn->carrier_id = 'AA'.
*
*          conn->connection_id = '04041'.
*
*          append conn to conns.
*
*          conn = new #(  ).
*
*          conn->carrier_id = 'BB'.
*
*          conn->connection_id = '04042'.
*
*          append conn to conns.
*
*          loop at conns into conn.
*                out->write( | Carrier ID : { conn->carrier_id } , Connection ID : { conn->connection_id }| ).
*          endloop.
*
*           CONN = new #(  ).
*           CONN->SET_ATTRIBUTES(
*                    exporting
*                        CARRIER_ID = 'BH'
*                        CONNECTION_ID = '0404'
*            ).
*            try.
*                CONN = new #( CARRIER_ID = 'LH'
*                              CONNECTION_ID = '0400'  ).
*            catch cx_abap_invalid_value.
*                out->write( |Either the carrier id is inital or connection id is initial| ).
*            endtry.
*
*            CONN->get_attributes(
*                            importing
*                            E_CARRIER_ID =  data(LC_CARRIER_ID)
*                            E_CONNECTION_ID = data(LC_CONNECTION_ID) ).
*
*            out->write( |CARRIER_ID : { LC_CARRIER_ID }| ).
*            out->write( |CONNECTION_ID : { LC_CONNECTION_ID }| ).
*           CONN->CARRIER_ID = 'BB'.
*
*           CONN->CONNECTION_ID = '04043'.

            data AIRPORT_FROM_ID type /DMO/AIRPORT_FROM_ID.
            data AIRPORT_TO_ID type /DMO/AIRPORT_TO_ID.

            select single from /DMO/CONNECTION
                fields AIRPORT_FROM_ID,AIRPORT_TO_ID
                    where CARRIER_ID = 'LH'
                    into (@AIRPORT_FROM_ID,@AIRPORT_TO_ID).

            try.
                conn = new #( carrier_id = 'SQ' connection_id = '0001' ).

                conn->set_airport_ids(  ).


                conn->get_attributes(
                       importing
                        e_airport_from_id = data(in_airport_from_id)
                        e_airport_to_id = data(in_airport_to_id) ).
                 out->write( |Airport from : { in_airport_from_id } Airport to : { in_airport_to_id }| ).

            catch cx_abap_invalid_value.
                out->write( 'The carrier id or connection id are not set' ).
            endtry.

             if SY-SUBRC = 0 .
                out->write( 'The query did executed correctly' ).

             else.
                out->write( 'The query did not executed correctly' ).
              endif.









    ENDMETHOD.
ENDCLASS.
