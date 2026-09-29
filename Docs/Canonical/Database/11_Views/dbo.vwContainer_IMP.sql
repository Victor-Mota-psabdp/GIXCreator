SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW dbo.vwContainer_IMP
AS
SELECT     HOU.Num_Proc_HIM AS Num_Proc, HOU.Num_Proc_MIM AS Num_Proc_Master, HOU.Item_Cont_IM AS Item_Cont, MAS.Cd_Tp_Cont, 
                      MAS.Num_Cont_IM AS Num_Cont, MAS.Num_Lacre_IM AS Num_Lacre, MAS.Dt_Vcto_Devol_IM AS Dt_Vcto_Devol, MAS.Dt_Devol_IM AS Dt_Devol, 
                      MAS.Lacre_02_IM AS Lacre_02, MAS.Lacre_03_IM AS Lacre_03, MAS.Lacre_04_IM AS Lacre_04, MAS.Peso_Bruto_IM AS Peso_Bruto, MAS.VolumeM3, MAS.ID_ISO, 
                      MAS.Tara_IM AS Tara, MAS.DataDevCli_IM AS DataDevCli, MAS.inspecao
FROM         dbo.Container_Mas_Imp_Mar AS MAS WITH (nolock) INNER JOIN
                      dbo.Container_Hou_Imp_Mar AS HOU WITH (nolock) ON HOU.Item_Cont_IM = MAS.Item_Cont_IM AND MAS.Num_Proc_MIM = HOU.Num_Proc_MIM

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
         Begin Table = "MAS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 207
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "HOU"
            Begin Extent = 
               Top = 6
               Left = 245
               Bottom = 99
               Right = 399
            End
            DisplayFlags = 280
            TopColumn = 0
         End
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwContainer_IMP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwContainer_IMP'
GO
