SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW dbo.vwPO_Imp
AS
SELECT     LLP.Num_Proc_LIM[Num_Proc], PO1.Numero_PO_HIM AS [Numero_PO], PO1.Data_PO_HIM AS [Data_PO], PO5.Numero_PO_HIM AS [Numero_DI], 
                      PO5.Data_PO_HIM AS [Data_DI], PO3.Data_PO_HIM[Order_Date], PO9.Numero_PO_HIM AS [Numero_Customer_PO], PO9.Data_PO_HIM AS Data_Customer_PO, 
                      PO7.Data_PO_HIM AS Data_Invoice, PO14.Numero_PO_HIM AS Courier, PO15.Numero_PO_HIM AS Courier_2nd, PO13.Data_PO_HIM[Certificado_origem], 
                      PO23.Numero_PO_HIM[LI_Number], PO85.Numero_PO_HIM[CE_Mercante_Master], PO29.Numero_PO_HIM[CE_Mercante], PO59.Numero_PO_HIM[Numero_DA]
FROM         dbo.LLP_Imp_Mar AS LLP WITH (nolock) LEFT OUTER JOIN
                      dbo.PO_HIM AS PO1 WITH (nolock) ON LLP.Num_Proc_LIM = PO1.Num_Proc_HIM AND PO1.ID_DC = '1' LEFT OUTER JOIN
                      dbo.PO_HIM AS PO3 WITH (nolock) ON LLP.Num_Proc_LIM = PO3.Num_Proc_HIM AND PO3.ID_DC = '3' LEFT OUTER JOIN
                      dbo.PO_HIM PO5 WITH (nolock) ON LLP.Num_Proc_LIM = PO5.Num_Proc_HIM AND PO5.ID_DC = '5' LEFT JOIN
                      dbo.PO_HIM AS PO9 WITH (nolock) ON LLP.Num_Proc_LIM = PO9.Num_Proc_HIM AND PO9.ID_DC = '9' LEFT OUTER JOIN
                      dbo.PO_HIM AS PO7 WITH (nolock) ON LLP.Num_Proc_LIM = PO7.Num_Proc_HIM AND PO7.ID_DC = '7' LEFT OUTER JOIN
                      dbo.PO_HIM AS PO13 WITH (nolock) ON LLP.Num_Proc_LIM = PO13.Num_Proc_HIM AND PO13.ID_DC = '13' LEFT OUTER JOIN
                      dbo.PO_HIM AS PO14 WITH (nolock) ON LLP.Num_Proc_LIM = PO14.Num_Proc_HIM AND PO14.ID_DC = '14' LEFT OUTER JOIN
                      dbo.PO_HIM AS PO15 WITH (nolock) ON LLP.Num_Proc_LIM = PO15.Num_Proc_HIM AND PO15.ID_DC = '15' LEFT OUTER JOIN
                      dbo.PO_HIM AS PO23 WITH (nolock) ON LLP.Num_Proc_LIM = PO23.Num_Proc_HIM AND PO23.ID_DC = '23' LEFT OUTER JOIN
                      dbo.PO_HIM AS PO85 WITH (nolock) ON LLP.Num_Proc_LIM = PO85.Num_Proc_HIM AND PO85.ID_DC = '85' LEFT OUTER JOIN
                      dbo.PO_HIM AS PO29 WITH (nolock) ON LLP.Num_Proc_LIM = PO29.Num_Proc_HIM AND PO29.ID_DC = '29' LEFT OUTER JOIN
                      dbo.PO_HIM AS PO59 WITH (nolock) ON LLP.Num_Proc_LIM = PO59.Num_Proc_HIM AND PO59.ID_DC = '59'
UNION
SELECT     LLP.Num_Proc_LIA, PO1.Numero_PO_HIA[Numero_PO], PO1.Data_PO_HIA[Data_PO], PO5.Numero_PO_HIA AS [Numero_DI], PO5.Data_PO_HIA AS [Data_DI], 
                      PO3.Data_PO_HIA[Order_Date], PO9.Numero_PO_HIA[Numero_Customer_PO], PO9.Data_PO_HIA[Data_Customer_PO], PO7.Data_PO_HIA[Data_Invoice], 
                      PO14.Numero_PO_HIA[Courier], PO15.Numero_PO_HIA[Courier_2nd], PO13.Data_PO_HIA[Certificado_origem], PO23.Numero_PO_HIA[LI_Number], 
                      '' [CE_Mercante_Master], '' [CE_Mercante], PO59.Numero_PO_HIA[Numero_DA]
FROM         LLP_Imp_AER LLP WITH (nolock) LEFT JOIN
                      PO_HIA PO1 WITH (nolock) ON LLP.Num_Proc_LIA = PO1.Num_Proc_HIA AND PO1.ID_DC = '1' LEFT JOIN
                      PO_HIA PO3 WITH (nolock) ON LLP.Num_Proc_LIA = PO3.Num_Proc_HIA AND PO3.ID_DC = '3' LEFT JOIN
                      PO_HIA PO5 WITH (nolock) ON LLP.Num_Proc_LIA = PO5.Num_Proc_HIA AND PO5.ID_DC = '5' LEFT JOIN
                      PO_HIA PO9 WITH (nolock) ON LLP.Num_Proc_LIA = PO9.Num_Proc_HIA AND PO9.ID_DC = '9' LEFT JOIN
                      PO_HIA PO7 WITH (nolock) ON LLP.Num_Proc_LIA = PO7.Num_Proc_HIA AND PO7.ID_DC = '7' LEFT JOIN
                      PO_HIA PO13 WITH (nolock) ON LLP.Num_Proc_LIA = PO13.Num_Proc_HIA AND PO13.ID_DC = '13' LEFT JOIN
                      PO_HIA PO14 WITH (nolock) ON LLP.Num_Proc_LIA = PO14.Num_Proc_HIA AND PO14.ID_DC = '14' LEFT JOIN
                      PO_HIA PO15 WITH (nolock) ON LLP.Num_Proc_LIA = PO15.Num_Proc_HIA AND PO15.ID_DC = '15' LEFT JOIN
                      PO_HIA PO23 WITH (nolock) ON LLP.Num_Proc_LIA = PO23.Num_Proc_HIA AND PO23.ID_DC = '23' LEFT OUTER JOIN
                      dbo.PO_HIA AS PO59 WITH (nolock) ON LLP.Num_Proc_LIA = PO59.Num_Proc_HIA AND PO59.ID_DC = '59'
UNION
SELECT     LLP.Num_Proc_LIO, PO1.Numero_PO_HIO[Numero_PO], PO1.Data_PO_HIO[Data_PO], PO5.Numero_PO_HIO AS [Numero_DI], PO5.Data_PO_HIO AS Data_DI, 
                      PO3.Data_PO_HIO[Order_Date], PO9.Numero_PO_HIO[Numero_Customer_PO], PO9.Data_PO_HIO[Data_Customer_PO], PO7.Data_PO_HIO[Data_Invoice], 
                      PO14.Numero_PO_HIO[Courier], PO15.Numero_PO_HIO[Courier_2nd], PO13.Data_PO_HIO[Certificado_origem], PO23.Numero_PO_HIO[LI_Number], 
                      '' [CE_Mercante_Master], '' [CE_Mercante], PO59.Numero_PO_HIO[Numero_DA]
FROM         LLP_Imp_Out LLP WITH (nolock) LEFT JOIN
                      PO_HIO PO1 WITH (nolock) ON LLP.Num_Proc_LIO = PO1.Num_Proc_HIO AND PO1.ID_DC = '1' LEFT JOIN
                      PO_HIO PO3 WITH (nolock) ON LLP.Num_Proc_LIO = PO3.Num_Proc_HIO AND PO3.ID_DC = '3' LEFT JOIN
                      PO_HIO PO5 WITH (nolock) ON LLP.Num_Proc_LIO = PO5.Num_Proc_HIO AND PO5.ID_DC = '5' LEFT JOIN
                      PO_HIO PO9 WITH (nolock) ON LLP.Num_Proc_LIO = PO9.Num_Proc_HIO AND PO9.ID_DC = '9' LEFT JOIN
                      PO_HIO PO7 WITH (nolock) ON LLP.Num_Proc_LIO = PO7.Num_Proc_HIO AND PO7.ID_DC = '7' LEFT JOIN
                      PO_HIO PO13 WITH (nolock) ON LLP.Num_Proc_LIO = PO13.Num_Proc_HIO AND PO13.ID_DC = '13' LEFT JOIN
                      PO_HIO PO14 WITH (nolock) ON LLP.Num_Proc_LIO = PO14.Num_Proc_HIO AND PO14.ID_DC = '14' LEFT JOIN
                      PO_HIO PO15 WITH (nolock) ON LLP.Num_Proc_LIO = PO15.Num_Proc_HIO AND PO15.ID_DC = '15' LEFT JOIN
                      PO_HIO PO23 WITH (nolock) ON LLP.Num_Proc_LIO = PO23.Num_Proc_HIO AND PO23.ID_DC = '23' LEFT OUTER JOIN
                      dbo.PO_HIO AS PO59 WITH (nolock) ON LLP.Num_Proc_LIO = PO59.Num_Proc_HIO AND PO59.ID_DC = '59'

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
         Top = -384
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPO_Imp'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPO_Imp'
GO
