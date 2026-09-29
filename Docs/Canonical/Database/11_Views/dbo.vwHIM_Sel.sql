SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwHIM_Sel]
AS
SELECT DISTINCT 
                      HOU.Num_Proc_HIM AS [01_BDP Reference], HOU.MAWB_HIM AS [02_MBL Number], HOU.HAWB_HIM AS [03_HBL Number], 
                      HOU.Num_Proc_MIM AS [04_Consol Reference], Ship.Apelido AS [05_Shipper Name], Consig.Apelido AS [06_Consignee Name], 
                      LI.Numero_PO_HIM AS [07_LI Number], Orig.Nome_Local AS [08_Loading], Destin.Nome_Local AS [09_Delivery], DstFinal.Nome_Local AS [10_Final Destination], 
                      HOU.Navio_HIM AS [11_Vessel Name], LLP.Courier_Number_Lim AS [12_Courier Number], LLP.ETD_Lim AS [13_ETD Date], LLP.ETA_Lim AS [14_ETA Date], 
                      LLP.ATD_lim AS [15_ATD Date], LLP.ATA_Lim AS [16_ATA Date], HOU.Obs_HIM AS [17_Note (OBS)], PO.Numero_PO_HIM AS [18_PO Number], 
                      INV.Numero_PO_HIM AS [19_Invoice Number], SO.Numero_PO_HIM AS [20_Sales Order], DI.Numero_PO_HIM AS [21_DI Number], 
                      CM.Num_Cont_IM AS [22_Container], Consig.Num_CPF_CNPJ AS [23_CNPJ], NTF.Apelido AS [24_Notify Name]
FROM         dbo.House_Imp_Mar AS HOU INNER JOIN
                      dbo.Pessoa AS Consig WITH (nolock) ON HOU.Cd_Consig_HIM = Consig.Cd_Pes INNER JOIN
                      dbo.Pessoa AS Ship WITH (nolock) ON HOU.Cd_Export_HIM = Ship.Cd_Pes INNER JOIN
                      dbo.Pessoa AS NTF WITH (nolock) ON HOU.Cd_Import_HIM = NTF.Cd_Pes INNER JOIN
                      dbo.Localidade AS Orig ON HOU.Cd_Org_HIM = Orig.Cd_Local INNER JOIN
                      dbo.Localidade AS Destin ON HOU.Cd_Dst_HIM = Destin.Cd_Local LEFT OUTER JOIN
                      dbo.PO_HIM AS PO ON PO.Num_Proc_HIM = HOU.Num_Proc_HIM AND PO.ID_DC = '1' LEFT OUTER JOIN
                      dbo.PO_HIM AS INV ON INV.Num_Proc_HIM = HOU.Num_Proc_HIM AND INV.ID_DC = '2' LEFT OUTER JOIN
                      dbo.PO_HIM AS SO ON SO.Num_Proc_HIM = HOU.Num_Proc_HIM AND SO.ID_DC = '3' LEFT OUTER JOIN
                      dbo.PO_HIM AS DI ON DI.Num_Proc_HIM = HOU.Num_Proc_HIM AND DI.ID_DC = '5' LEFT OUTER JOIN
                      dbo.PO_HIM AS LI ON LI.Num_Proc_HIM = HOU.Num_Proc_HIM AND LI.ID_DC = '23' INNER JOIN
                      dbo.LLP_Imp_Mar AS LLP ON HOU.Num_Proc_HIM = LLP.Num_Proc_Lim LEFT OUTER JOIN
                      dbo.Localidade AS DstFinal ON LLP.Cd_DstFinal_Lim = DstFinal.Cd_Local LEFT OUTER JOIN
                      dbo.Container_Hou_Imp_Mar AS CH ON LLP.Num_Proc_Lim = CH.Num_Proc_HIM LEFT OUTER JOIN
                      dbo.Container_Mas_Imp_Mar AS CM ON CH.Num_Proc_MIM = CM.Num_Proc_MIM AND CH.Item_Cont_IM = CM.Item_Cont_IM

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
         Begin Table = "HOU"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 223
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Consig"
            Begin Extent = 
               Top = 6
               Left = 261
               Bottom = 114
               Right = 437
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Ship"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "NTF"
            Begin Extent = 
               Top = 114
               Left = 252
               Bottom = 222
               Right = 428
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Orig"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Destin"
            Begin Extent = 
               Top = 222
               Left = 227
               Bottom = 330
               Right = 378
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PO"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 200
            End
            DisplayFlags = 280
            TopColumn' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwHIM_Sel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' = 0
         End
         Begin Table = "INV"
            Begin Extent = 
               Top = 330
               Left = 238
               Bottom = 438
               Right = 400
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SO"
            Begin Extent = 
               Top = 438
               Left = 38
               Bottom = 546
               Right = 200
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DI"
            Begin Extent = 
               Top = 438
               Left = 238
               Bottom = 546
               Right = 400
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LI"
            Begin Extent = 
               Top = 546
               Left = 38
               Bottom = 654
               Right = 200
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LLP"
            Begin Extent = 
               Top = 546
               Left = 238
               Bottom = 654
               Right = 417
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DstFinal"
            Begin Extent = 
               Top = 654
               Left = 38
               Bottom = 762
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CH"
            Begin Extent = 
               Top = 654
               Left = 227
               Bottom = 747
               Right = 381
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CM"
            Begin Extent = 
               Top = 750
               Left = 227
               Bottom = 858
               Right = 396
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwHIM_Sel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwHIM_Sel'
GO
