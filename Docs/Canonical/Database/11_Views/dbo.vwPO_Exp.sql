SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwPO_Exp]
AS
SELECT     LLP.Num_Proc_LEM[Num_Proc], PO1.Numero_PO_HEM AS [Numero_PO], PO1.Data_PO_HEM AS [Data_PO], PO5.Numero_PO_HEM AS [Numero_DI], 
                      PO3.Data_PO_HEM[Order_Date], PO3.Numero_PO_HEM[Sales_Order], PO4.Numero_PO_HEM[RE_Number], PO4.Data_PO_HEM[RE_Date], 
                      PO5.Data_PO_HEM AS [ Data_DI], PO9.Numero_PO_HEM AS [Numero_Customer_PO], PO9.Data_PO_HEM AS Data_Customer_PO, 
                      PO8.Numero_PO_HEM AS [Numero_Shipment], PO8.Data_PO_HEM AS [Shipment_Data], PO10.Numero_PO_HEM AS [Numero_NF], 
                      PO10.Data_PO_HEM AS Data_NF, PO12.Numero_PO_HEM[DDE_Number], PO12.Data_PO_HEM[DDE_Date], PO94.Numero_PO_HEM AS Courier_2nd,
                      PO103.Numero_PO_HEM[Courier], PO36.Numero_PO_HEM [Direct_Collection], PO30.Numero_PO_HEM [Arktec_Num]
FROM         dbo.LLP_Exp_Mar AS LLP WITH (nolock) LEFT OUTER JOIN
                      dbo.PO_HEM AS PO1 WITH (nolock) ON LLP.Num_Proc_LEM = PO1.Num_Proc_HEM AND PO1.ID_DC = '1' LEFT OUTER JOIN
                      dbo.PO_HEM AS PO3 WITH (nolock) ON LLP.Num_Proc_LEM = PO3.Num_Proc_HEM AND PO3.ID_DC = '3' LEFT OUTER JOIN
                      dbo.PO_HEM AS PO4 WITH (nolock) ON LLP.Num_Proc_LEM = PO4.Num_Proc_HEM AND PO4.ID_DC = '4' LEFT OUTER JOIN
                      dbo.PO_HEM AS PO5 WITH (nolock) ON LLP.Num_Proc_LEM = PO5.Num_Proc_HEM AND PO5.ID_DC = '5' LEFT OUTER JOIN
                      dbo.PO_HEM AS PO7 WITH (nolock) ON LLP.Num_Proc_LEM = PO7.Num_Proc_HEM AND PO7.ID_DC = '7' LEFT OUTER JOIN
                      dbo.PO_HEM AS PO8 WITH (nolock) ON LLP.Num_Proc_LEM = PO8.Num_Proc_HEM AND PO8.ID_DC = '8' LEFT OUTER JOIN
                      dbo.PO_HEM AS PO9 WITH (nolock) ON LLP.Num_Proc_LEM = PO9.Num_Proc_HEM AND PO9.ID_DC = '9' LEFT OUTER JOIN
                      dbo.PO_HEM AS PO10 WITH (nolock) ON LLP.Num_Proc_LEM = PO10.Num_Proc_HEM AND PO10.ID_DC = '10' LEFT OUTER JOIN
                      dbo.PO_HEM AS PO12 WITH (nolock) ON LLP.Num_Proc_LEM = PO12.Num_Proc_HEM AND PO12.ID_DC = '12' LEFT OUTER JOIN
                      dbo.PO_HEM AS PO14 WITH (nolock) ON LLP.Num_Proc_LEM = PO14.Num_Proc_HEM AND PO14.ID_DC = '14' LEFT OUTER JOIN
                      dbo.PO_HEM AS PO30 WITH (nolock) ON LLP.Num_Proc_LEM = PO30.Num_Proc_HEM AND PO30.ID_DC = '30' LEFT OUTER JOIN
                      dbo.PO_HEM AS PO36 WITH (nolock) ON LLP.Num_Proc_LEM = PO36.Num_Proc_HEM AND PO36.ID_DC = '36' LEFT OUTER JOIN
                      dbo.PO_HEM AS PO94 WITH (nolock) ON LLP.Num_Proc_LEM = PO94.Num_Proc_HEM AND PO94.ID_DC = '94' LEFT OUTER JOIN
                      dbo.PO_HEM AS PO103 WITH (nolock) ON LLP.Num_Proc_LEM = PO103.Num_Proc_HEM AND PO103.ID_DC = '103'
                     
                    
                      
UNION
SELECT     LLP.Num_Proc_LEA[Num_Proc], PO1.Numero_PO_HEA AS [Numero_PO], PO1.Data_PO_HEA AS [Data_PO], PO5.Numero_PO_HEA AS [Numero_DI], 
                      PO3.Data_PO_HEA[Order_Date], PO3.Numero_PO_HEA[Sales_Order], PO4.Numero_PO_HEA[RE_Number], PO4.Data_PO_HEA[RE_Date], 
                      PO5.Data_PO_HEA AS [Data_DI], PO9.Numero_PO_HEA AS [Numero_Customer_PO], PO9.Data_PO_HEA[Data_Customer_PO], 
                      PO8.Numero_PO_HEA AS [Numero_Shipment], PO8.Data_PO_HEA AS [Shipment_Data], PO10.Numero_PO_HEA AS [Numero_NF], 
                      PO10.Data_PO_HEA AS Data_NF, PO12.Numero_PO_HEA[DDE_Number], PO12.Data_PO_HEA[DDE_Date], PO94.Numero_PO_HEA[Courier_2nd], 
                      PO103.Numero_PO_HEA[Courier], PO36.Numero_PO_HEA [Direct_Collection], PO30.Numero_PO_HEA [Arktec_Num]
FROM         LLP_Exp_Aer LLP WITH (nolock) LEFT JOIN
                      dbo.PO_HEA PO1 WITH (nolock) ON LLP.Num_Proc_LEA = PO1.Num_Proc_HEA AND PO1.ID_DC = '1' LEFT JOIN
                      dbo.PO_HEA PO3 WITH (nolock) ON LLP.Num_Proc_LEA = PO3.Num_Proc_HEA AND PO3.ID_DC = '3' LEFT JOIN
                      dbo.PO_HEA PO4 WITH (nolock) ON LLP.Num_Proc_LEA = PO4.Num_Proc_HEA AND PO4.ID_DC = '4' LEFT JOIN
                      dbo.PO_HEA PO5 WITH (nolock) ON LLP.Num_Proc_LEA = PO5.Num_Proc_HEA AND PO5.ID_DC = '5' LEFT JOIN
                      dbo.PO_HEA PO7 WITH (nolock) ON LLP.Num_Proc_LEA = PO7.Num_Proc_HEA AND PO7.ID_DC = '7' LEFT JOIN
                      dbo.PO_HEA PO8 WITH (nolock) ON LLP.Num_Proc_LEA = PO8.Num_Proc_HEA AND PO8.ID_DC = '8' LEFT JOIN
                      dbo.PO_HEA PO9 WITH (nolock) ON LLP.Num_Proc_LEA = PO9.Num_Proc_HEA AND PO9.ID_DC = '9' LEFT JOIN
                      dbo.PO_HEA PO10 WITH (nolock) ON LLP.Num_Proc_LEA = PO10.Num_Proc_HEA AND PO10.ID_DC = '10' LEFT JOIN
                      dbo.PO_HEA PO12 WITH (nolock) ON LLP.Num_Proc_LEA = PO12.Num_Proc_HEA AND PO12.ID_DC = '12' LEFT JOIN
                      dbo.PO_HEA PO14 WITH (nolock) ON LLP.Num_Proc_LEA = PO14.Num_Proc_HEA AND PO14.ID_DC = '14' LEFT JOIN
                      dbo.PO_HEA PO30 WITH (nolock) ON LLP.Num_Proc_LEA = PO30.Num_Proc_HEA AND PO30.ID_DC = '30' LEFT JOIN
                      dbo.PO_HEA PO36 WITH (nolock) ON LLP.Num_Proc_LEA = PO36.Num_Proc_HEA AND PO36.ID_DC = '36' LEFT JOIN
                      dbo.PO_HEA PO94 WITH (nolock) ON LLP.Num_Proc_LEA = PO94.Num_Proc_HEA AND PO94.ID_DC = '94' LEFT JOIN
                      dbo.PO_HEA PO103 WITH (nolock) ON LLP.Num_Proc_LEA = PO103.Num_Proc_HEA AND PO103.ID_DC = '103'
UNION
SELECT     LLP.Num_Proc_LEO[Num_Proc], PO1.Numero_PO_HEO AS [Numero_PO], PO1.Data_PO_HEO AS [Data_PO], PO5.Numero_PO_HEO AS [Numero_DI], 
                      PO3.Data_PO_HEO[Order_Date], PO3.Numero_PO_HEO[Sales_Order], PO4.Numero_PO_HEO[RE_Number], PO4.Data_PO_HEO[RE_Date], 
                      PO5.Data_PO_HEO AS Data_DI, PO9.Numero_PO_HEO AS [Numero_Customer_PO], PO9.Data_PO_HEO[Data_Customer_PO],
                      PO8.Numero_PO_HEO AS [Numero_Shipment], PO8.Data_PO_HEO [Shipment_Data], PO10.Numero_PO_HEO AS [Numero_NF], 
                      PO10.Data_PO_HEO AS Data_NF, PO12.Numero_PO_HEO [DDE_Number], PO12.Data_PO_HEO[DDE_Date], PO94.Numero_PO_HEO[Courier_2nd], 
                      PO103.Numero_PO_HEO[Courier], PO36.Numero_PO_HEO [Direct_Collection], PO30.Numero_PO_HEO [Arktec_Num]
FROM         LLP_Exp_Out LLP WITH (nolock) LEFT JOIN
                      dbo.PO_HEO PO1 WITH (nolock) ON LLP.Num_Proc_LEO = PO1.Num_Proc_HEO AND PO1.ID_DC = '1' LEFT JOIN
                      dbo.PO_HEO PO3 WITH (nolock) ON LLP.Num_Proc_LEO = PO3.Num_Proc_HEO AND PO3.ID_DC = '3' LEFT JOIN
                      dbo.PO_HEO PO4 WITH (nolock) ON LLP.Num_Proc_LEO = PO4.Num_Proc_HEO AND PO4.ID_DC = '4' LEFT JOIN
                      dbo.PO_HEO PO5 WITH (nolock) ON LLP.Num_Proc_LEO = PO5.Num_Proc_HEO AND PO5.ID_DC = '5' LEFT JOIN
                      dbo.PO_HEO PO7 WITH (nolock) ON LLP.Num_Proc_LEO = PO7.Num_Proc_HEO AND PO7.ID_DC = '7' LEFT JOIN
                      dbo.PO_HEO PO8 WITH (nolock) ON LLP.Num_Proc_LEO = PO8.Num_Proc_HEO AND PO8.ID_DC = '8' LEFT JOIN
                      dbo.PO_HEO PO9 WITH (nolock) ON LLP.Num_Proc_LEO = PO9.Num_Proc_HEO AND PO9.ID_DC = '9' LEFT JOIN
                      dbo.PO_HEO PO10 WITH (nolock) ON LLP.Num_Proc_LEO = PO10.Num_Proc_HEO AND PO10.ID_DC = '10' LEFT JOIN
                      dbo.PO_HEO PO12 WITH (nolock) ON LLP.Num_Proc_LEO = PO12.Num_Proc_HEO AND PO12.ID_DC = '12' LEFT JOIN
                      dbo.PO_HEO PO14 WITH (nolock) ON LLP.Num_Proc_LEO = PO14.Num_Proc_HEO AND PO14.ID_DC = '14' LEFT JOIN
                      dbo.PO_HEO PO30 WITH (nolock) ON LLP.Num_Proc_LEO = PO30.Num_Proc_HEO AND PO30.ID_DC = '30' LEFT JOIN
                      dbo.PO_HEO PO36 WITH (nolock) ON LLP.Num_Proc_LEO = PO36.Num_Proc_HEO AND PO36.ID_DC = '36' LEFT JOIN
                      dbo.PO_HEO PO94 WITH (nolock) ON LLP.Num_Proc_LEO = PO94.Num_Proc_HEO AND PO94.ID_DC = '94' LEFT JOIN
                      dbo.PO_HEO PO103 WITH (nolock) ON LLP.Num_Proc_LEO = PO103.Num_Proc_HEO AND PO103.ID_DC = '103'



GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPO_Exp'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPO_Exp'
GO
