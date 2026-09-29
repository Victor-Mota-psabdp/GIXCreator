SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW dbo.vwALL_JOBs
AS
SELECT     LLP.Num_Proc_Lim Num_Proc, HOU.HAWB_HIM HAWB, HOU.MAWB_HIM MAWB, ID_Status
FROM         LLP_imp_Mar LLP WITH (nolock) JOIN
                      House_Imp_Mar HOU WITH (nolock) ON LLP.Num_Proc_Lim = HOU.Num_Proc_HIM
UNION ALL
SELECT     Num_Proc_Lia Num_Proc, HOU.HAWB_HIA HAWB, HOU.MAWB_HIA MAWB, ID_Status
FROM         LLP_imp_Aer LLP WITH (nolock) JOIN
                      House_Imp_Aer HOU WITH (nolock) ON LLP.Num_Proc_Lia = HOU.Num_Proc_HIA
UNION ALL
SELECT     Num_Proc_LiO Num_Proc, HOU.HAWB_HIO HAWB, HOU.MAWB_HIO MAWB, ID_Status
FROM         LLP_imp_Out LLP WITH (nolock) JOIN
                      House_Imp_Out HOU WITH (nolock) ON LLP.Num_Proc_Lio = HOU.Num_Proc_HIO
UNION ALL
SELECT     Num_Proc_LEm Num_Proc, HOU.HAWB_HEM HAWB, HOU.MAWB_HEM MAWB, ID_Status
FROM         LLP_exp_Mar LLP WITH (nolock) JOIN
                      House_Exp_Mar HOU WITH (nolock) ON LLP.Num_Proc_Lem = HOU.Num_Proc_HEM
UNION ALL
SELECT     Num_Proc_LEa Num_Proc, HOU.HAWB_HEA HAWB, HOU.MAWB_HEA MAWB, ID_Status
FROM         LLP_exp_Aer LLP WITH (nolock) JOIN
                      House_Exp_Aer HOU WITH (nolock) ON LLP.Num_Proc_Lea = HOU.Num_Proc_Hea
UNION ALL
SELECT     Num_Proc_LEO Num_Proc, HOU.HAWB_HEO HAWB, HOU.MAWB_HEO MAWB, ID_Status
FROM         LLP_exp_Out LLP WITH (nolock) JOIN
                      House_Exp_Out HOU WITH (nolock) ON LLP.Num_Proc_Leo = HOU.Num_Proc_HEO
UNION ALL
SELECT     Num_Proc_LBO Num_Proc, NULL HAWB, NULL MAWB, ID_Status
FROM         LLP_BDP_Out LLP WITH (nolock) JOIN
                      House_BDP_Out HOU WITH (nolock) ON LLP.Num_Proc_LBO = HOU.Num_Proc_HBO

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
         Top = -288
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwALL_JOBs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwALL_JOBs'
GO
