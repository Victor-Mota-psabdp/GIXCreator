SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW dbo.vwCustomerProfile_Sel
AS
SELECT DISTINCT 
                      CONVERT(varchar, CP.ID_CP) AS [01_ID], AP.Apelido AS [02_Customer_Name], LO.Nome_Local AS [03_Origin], LD.Nome_Local AS [04_Destination], 
                      CP.Modal AS [05_Modal], CP.Data AS [06_Date], AG.Apelido AS [07_Agent], SA.Apelido AS [08_Sub-Agente], VE.Nome_Usuario AS [09_Sales Representative], 
                      TS.Descr_Servico AS [10_Type of Service], CP.Dt_Vencimento AS [11_Due Date], ST.Descr_Status AS [12_Status], TC.Nome_Tp_Carga AS [13_Type of Cargo]
FROM         dbo.Customer_Profile AS CP WITH (nolock) INNER JOIN
                      dbo.Pessoa AS AP WITH (nolock) ON AP.Cd_Pes = CP.Cd_Cliente LEFT OUTER JOIN
                      dbo.Localidade AS LO WITH (nolock) ON LO.Cd_Local = CP.Cd_Org LEFT OUTER JOIN
                      dbo.Localidade AS LD WITH (nolock) ON LD.Cd_Local = CP.Cd_Dst LEFT OUTER JOIN
                      dbo.Pessoa AS AG WITH (nolock) ON AG.Cd_Pes = CP.Cd_Agente LEFT OUTER JOIN
                      dbo.Pessoa AS SA WITH (nolock) ON SA.Cd_Pes = CP.Cd_SubAgente LEFT OUTER JOIN
                      dbo.Usuario AS VE WITH (nolock) ON VE.Cd_Usuario = CP.Cd_Vendedor INNER JOIN
                      dbo.Tipo_Servico_CP AS TS WITH (nolock) ON CP.Cd_Tipo_Servico = TS.Cd_Tipo_Servico LEFT OUTER JOIN
                      dbo.Tipo_Status_CP AS ST WITH (nolock) ON CP.ID_Status_CP = ST.ID_Status_CP LEFT OUTER JOIN
                      dbo.Tipo_Carga AS TC WITH (nolock) ON CP.Tipo_Carga = TC.Cd_Tp_Carga

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
         Top = -24
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CP"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AP"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 114
               Right = 412
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LO"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LD"
            Begin Extent = 
               Top = 114
               Left = 227
               Bottom = 222
               Right = 378
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AG"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SA"
            Begin Extent = 
               Top = 222
               Left = 252
               Bottom = 330
               Right = 428
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VE"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
      ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCustomerProfile_Sel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'   End
         Begin Table = "TS"
            Begin Extent = 
               Top = 330
               Left = 227
               Bottom = 408
               Right = 387
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ST"
            Begin Extent = 
               Top = 30
               Left = 450
               Bottom = 123
               Right = 601
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TC"
            Begin Extent = 
               Top = 30
               Left = 639
               Bottom = 123
               Right = 799
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
         Alias = 2895
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCustomerProfile_Sel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCustomerProfile_Sel'
GO
