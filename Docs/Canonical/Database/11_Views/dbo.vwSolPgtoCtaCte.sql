SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwSolPgtoCtaCte]
AS
SELECT     SP.ID AS [Register Number], 
			SP.Cd_Cred_Dev AS [Code Debitor], 
			PS.Apelido AS [Name Debitor], 
			PS.Num_CPF_CNPJ AS CNPJ, 
			SP.Dt_Pgto_Rcto AS [Register Date], 
            SP.Vlr_Doc AS [Value Debit], 
            SP.Dt_Vcto AS [Due Date], 
            SP.Cd_Tp_Doc AS [Code Document],
            TD.Nome_Tp_Doc AS [Name Document], 
            SOL.Nome_Usuario AS Solicitante, 
            GR.Nome_Usuario AS Gerente, 
            DR.Nome_Usuario AS Diretor, 
            (CASE WHEN SP.Status = 1 AND (GR.Cd_Usuario = '' OR
                GR.Cd_Usuario IS NULL) THEN 'Created' WHEN SP.Status = 1 AND (GR.Cd_Usuario <> '' OR
               GR.Cd_Usuario IS NOT NULL) THEN 'Approved' ELSE 'Canceled' END) AS Status
FROM         dbo.Sol_Pgto_Cta_Cte AS SP WITH (nolock) INNER JOIN
                      dbo.Usuario AS SOL ON SP.Cd_Solicitante = SOL.Cd_Usuario LEFT OUTER JOIN
                      dbo.Usuario AS GR ON SP.Cd_Gerente = GR.Cd_Usuario LEFT OUTER JOIN
                      dbo.Usuario AS DR ON SP.Cd_Diretor = DR.Cd_Usuario INNER JOIN
                      dbo.Pessoa AS PS ON SP.Cd_Cred_Dev = PS.Cd_Pes INNER JOIN
                      dbo.Tipo_Documento AS TD ON SP.Cd_Tp_Doc = TD.Cd_Tp_Doc                    
                     




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
         Begin Table = "SP"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SOL"
            Begin Extent = 
               Top = 6
               Left = 227
               Bottom = 114
               Right = 378
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "GR"
            Begin Extent = 
               Top = 6
               Left = 416
               Bottom = 114
               Right = 567
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DR"
            Begin Extent = 
               Top = 6
               Left = 605
               Bottom = 114
               Right = 756
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PS"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TD"
            Begin Extent = 
               Top = 114
               Left = 252
               Bottom = 207
               Right = 403
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
         Column = 2160
         Alias = 1560
         Table = 1170
 ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwSolPgtoCtaCte'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'        Output = 720
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwSolPgtoCtaCte'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwSolPgtoCtaCte'
GO
