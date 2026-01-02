CLASS zabap_pract5 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zabap_pract5 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DELETE FROM zcurre_rates.

    DATA zcurre_rates_lt TYPE TABLE OF zcurre_rates.

    DATA zcurre_rates_wa LIKE LINE OF zcurre_rates_lt.

    DATA(lt_csv) = VALUE string_table(
        ( `100,EUR,AED,20250101,3.9600` )
        ( `100,EUR,AFN,20250101,78.5000` )
        ( `100,EUR,ALL,20250101,103.2000` )
        ( `100,EUR,AMD,20250101,430.5000` )
        ( `100,EUR,ANG,20250101,1.9600` )
        ( `100,EUR,AOA,20250101,905.0000` )
        ( `100,EUR,ARS,20250101,905.0000` )
        ( `100,EUR,AUD,20250101,1.6200` )
        ( `100,EUR,AWG,20250101,1.9600` )
        ( `100,EUR,AZN,20250101,1.8400` )
        ( `100,EUR,BAM,20250101,1.9600` )
        ( `100,EUR,BBD,20250101,2.1600` )
        ( `100,EUR,BDT,20250101,118.0000` )
        ( `100,EUR,BGN,20250101,1.9600` )
        ( `100,EUR,BHD,20250101,0.4100` )
        ( `100,EUR,BIF,20250101,3100.0000` )
        ( `100,EUR,BMD,20250101,1.0800` )
        ( `100,EUR,BND,20250101,1.4600` )
        ( `100,EUR,BOB,20250101,7.4500` )
        ( `100,EUR,BRL,20250101,5.3500` )
        ( `100,EUR,BSD,20250101,1.0800` )
        ( `100,EUR,BTN,20250101,90.5000` )
        ( `100,EUR,BWP,20250101,14.6000` )
        ( `100,EUR,BYN,20250101,3.5500` )
        ( `100,EUR,BYR,20250101,21500.0000` )
        ( `100,EUR,BZD,20250101,2.1600` )
        ( `100,EUR,CAD,20250101,1.4700` )
        ( `100,EUR,CDF,20250101,2950.0000` )
        ( `100,EUR,CHF,20250101,0.9600` )
        ( `100,EUR,CLF,20250101,0.0350` )
        ( `100,EUR,CLP,20250101,960.0000` )
        ( `100,EUR,CNY,20250101,7.8500` )
        ( `100,EUR,COP,20250101,4250.0000` )
        ( `100,EUR,CRC,20250101,560.0000` )
        ( `100,EUR,CUP,20250101,26.5000` )
        ( `100,EUR,CVE,20250101,110.3000` )
        ( `100,EUR,CZK,20250101,24.6000` )
        ( `100,EUR,DJF,20250101,192.0000` )
        ( `100,EUR,DKK,20250101,7.4500` )
        ( `100,EUR,DOP,20250101,63.0000` )
        ( `100,EUR,DZD,20250101,145.0000` )
        ( `100,EUR,EGP,20250101,33.5000` )
        ( `100,EUR,ERN,20250101,16.2000` )
        ( `100,EUR,ETB,20250101,60.5000` )
        ( `100,EUR,FJD,20250101,2.4200` )
        ( `100,EUR,FKP,20250101,0.8600` )
        ( `100,EUR,GBP,20250101,0.8600` )
        ( `100,EUR,GEL,20250101,2.9500` )
        ( `100,EUR,GHS,20250101,12.8000` )
        ( `100,EUR,GIP,20250101,0.8600` )
        ( `100,EUR,GMD,20250101,72.0000` )
        ( `100,EUR,GNF,20250101,9300.0000` )
        ( `100,EUR,GTQ,20250101,8.4500` )
        ( `100,EUR,GYD,20250101,225.0000` )
        ( `100,EUR,HKD,20250101,8.4500` )
        ( `100,EUR,HNL,20250101,26.8000` )
        ( `100,EUR,HRK,20250101,7.5300` )
        ( `100,EUR,HTG,20250101,145.0000` )
        ( `100,EUR,HUF,20250101,382.0000` )
        ( `100,EUR,IDR,20250101,17000.0000` )
        ( `100,EUR,ILS,20250101,3.9500` )
        ( `100,EUR,INR,20250101,90.5000` )
        ( `100,EUR,IQD,20250101,1410.0000` )
        ( `100,EUR,IRR,20250101,45500.0000` )
        ( `100,EUR,ISK,20250101,150.0000` )
        ( `100,EUR,JMD,20250101,168.0000` )
        ( `100,EUR,JOD,20250101,0.7700` )
        ( `100,EUR,JPY,20250101,158.0000` )
        ( `100,EUR,KES,20250101,170.0000` )
        ( `100,EUR,KGS,20250101,96.0000` )
        ( `100,EUR,KHR,20250101,4450.0000` )
        ( `100,EUR,KMF,20250101,492.0000` )
        ( `100,EUR,KPW,20250101,970.0000` )
        ( `100,EUR,KRW,20250101,1450.0000` )
        ( `100,EUR,KWD,20250101,0.3300` )
        ( `100,EUR,KYD,20250101,0.9000` )
        ( `100,EUR,KZT,20250101,490.0000` )
        ( `100,EUR,LAK,20250101,23000.0000` )
        ( `100,EUR,LBP,20250101,16500.0000` )
        ( `100,EUR,LKR,20250101,345.0000` )
        ( `100,EUR,LRD,20250101,210.0000` )
        ( `100,EUR,LSL,20250101,20.2000` )
        ( `100,EUR,LYD,20250101,5.2500` )
        ( `100,EUR,MAD,20250101,10.8500` )
        ( `100,EUR,MDL,20250101,19.3000` )
        ( `100,EUR,MGA,20250101,4800.0000` )
        ( `100,EUR,MKD,20250101,61.5000` )
        ( `100,EUR,MMK,20250101,2300.0000` )
        ( `100,EUR,MNT,20250101,3700.0000` )
        ( `100,EUR,MOP,20250101,8.7500` )
        ( `100,EUR,MRU,20250101,42.5000` )
        ( `100,EUR,MUR,20250101,49.5000` )
        ( `100,EUR,MVR,20250101,16.6000` )
        ( `100,EUR,MWK,20250101,1900.0000` )
        ( `100,EUR,MXN,20250101,18.4000` )
        ( `100,EUR,MXV,20250101,0.0530` )
        ( `100,EUR,MYR,20250101,5.0500` )
        ( `100,EUR,MZN,20250101,68.5000` )
        ( `100,EUR,NAD,20250101,20.2000` )
        ( `100,EUR,INR,20250101,105.9100` )
        ( `100,EUR,USD,20250101,1.1700` )
      ).


    LOOP AT lt_csv INTO DATA(lv_line).
      SPLIT lv_line AT ',' INTO TABLE DATA(lt_fields).
      APPEND VALUE #( client = CONV mandt( lt_fields[ 1 ] ) from_curr = lt_fields[ 2 ]
                       to_curr = lt_fields[ 3 ] valid_from = lt_fields[ 4 ] rate = lt_fields[ 5 ] )
                        TO zcurre_rates_lt.
    ENDLOOP.

    LOOP AT zcurre_rates_lt INTO zcurre_rates_wa.
      INSERT zcurre_rates FROM @zcurre_rates_wa.
    ENDLOOP.

    IF sy-subrc = 0.
        out->write( 'Successfully executed' ).
    ELSE.
        out->write( 'Not Successfully executed' ).
    ENDIF.



  ENDMETHOD.
ENDCLASS.
