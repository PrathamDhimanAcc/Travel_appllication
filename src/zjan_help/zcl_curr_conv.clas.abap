CLASS zcl_curr_conv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS convert_amount
      IMPORTING iv_amount           TYPE yamount
                iv_from_curr        TYPE ycurr
                iv_to_curr          TYPE ycurr
                iv_date             TYPE d
      RETURNING VALUE(rv_converted) TYPE yamount.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_curr_conv IMPLEMENTATION.
  METHOD convert_amount.

    DATA: lv_eur_to   TYPE zcurre_rates-rate,
          lv_eur_from TYPE zcurre_rates-rate.

    " EUR -> target
    SELECT SINGLE rate
      FROM zcurre_rates
      WHERE  from_curr  = 'EUR'
        AND to_curr    = @iv_to_curr
        AND valid_from <= @iv_date
      INTO @lv_eur_to.

    " EUR -> source
    SELECT SINGLE rate
      FROM zcurre_rates
      WHERE  from_curr  = 'EUR'
        AND to_curr    = @iv_from_curr
        AND valid_from <= @iv_date
      INTO @lv_eur_from.

    IF lv_eur_to IS INITIAL OR lv_eur_from IS INITIAL.
      rv_converted = 0.   " or raise exception
      RETURN.
    ENDIF.

    rv_converted = iv_amount * ( lv_eur_to / lv_eur_from ).

  ENDMETHOD.
ENDCLASS.

