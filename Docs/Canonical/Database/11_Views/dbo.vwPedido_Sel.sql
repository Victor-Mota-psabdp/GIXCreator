SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW dbo.vwPedido_Sel
AS
SELECT DISTINCT 
                      CONVERT(char, P.Cd_pedido) AS [00 ID], P.Num_Pedido AS [01 Order Reference], P.Dt_Pedido AS [02 Order Date], GR.Apelido AS [03 Group in BDP], 
                      Seller.Apelido AS [04 Seller Name], Buyer.Apelido AS [05 Buyer Name], Org.Nome_Pais AS [06 Origin Country], Dst.Nome_Pais AS [07 Destination Country], 
                      P.Incoterm AS [08 Incoterm], P.cd_modal AS [09 Modal], P.DL_Chegada AS [10 PO Req. Deliv.], P.Status AS [11 Status], P.Customer_PO AS [12 Customer PO], 
                      P.Num_PO AS [13 PO Number], P.Planta AS [14 Plant ID]
FROM         dbo.Pedido AS P WITH (nolock) INNER JOIN
                      dbo.Pessoa AS Seller WITH (nolock) ON Seller.Cd_Pes = P.Cd_Seller INNER JOIN
                      dbo.Pessoa AS Buyer WITH (nolock) ON Buyer.Cd_Pes = P.Cd_Buyer INNER JOIN
                      dbo.Pessoa AS GR WITH (nolock) ON GR.Cd_Pes = P.Cd_Grupo LEFT OUTER JOIN
                      dbo.Pais AS Org WITH (nolock) ON Org.Cd_Pais = P.Cd_Pais_Org LEFT OUTER JOIN
                      dbo.Pais AS Dst WITH (nolock) ON Dst.Cd_Pais = P.Cd_Pais_Dst
WHERE     (P.Dt_Pedido > GETDATE() - 365 * 2)

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
         Begin Table = "P"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 219
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Seller"
            Begin Extent = 
               Top = 6
               Left = 257
               Bottom = 114
               Right = 433
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Buyer"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "GR"
            Begin Extent = 
               Top = 114
               Left = 252
               Bottom = 222
               Right = 428
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Org"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 315
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Dst"
            Begin Extent = 
               Top = 222
               Left = 227
               Bottom = 315
               Right = 378
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
         Table ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPedido_Sel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'= 1170
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPedido_Sel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPedido_Sel'
GO
