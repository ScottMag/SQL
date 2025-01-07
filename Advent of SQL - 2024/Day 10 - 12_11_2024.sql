SELECT SUB.DATE, SUB.[EGGNOG], SUB.[SHERRY], SUB.[BAILEYS], SUB.[PEPPERMINT SCHNAPPS], SUB.[HOT COCOA], SUB.[MULLED WINE]
  FROM (SELECT D.DATE
             , SUM(IIF(D.DRINK_NAME = 'Eggnog'             , d.quantity, 0)) AS [Eggnog]
             , SUM(IIF(d.drink_name = 'Sherry'             , d.quantity, 0)) AS [Sherry]
             , SUM(IIF(d.drink_name = 'Baileys'            , d.quantity, 0)) AS [Baileys]
             , SUM(IIF(d.drink_name = 'Hot Cocoa'          , d.quantity, 0)) AS [Hot Cocoa]
             , SUM(IIF(d.drink_name = 'Peppermint Schnapps', d.quantity, 0)) AS [Peppermint Schnapps]
             , SUM(IIF(d.drink_name = 'Mulled wine'        , d.quantity, 0)) AS [Mulled wine]
          FROM DBO.DRINKS AS D
         GROUP BY D.DATE
       ) AS SUB
 WHERE SUB.[HOT COCOA] = 38 AND SUB.[PEPPERMINT SCHNAPPS] =  298 AND SUB.EGGNOG = 198