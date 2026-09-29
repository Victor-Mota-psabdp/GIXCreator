SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW dbo.vwCampoCliente
AS
SELECT     TCC.Id_Campo, TCC.Descr_Campo, ISNULL(CP.Campo_Dados, '') AS Campo_Dados, TCC.Tab_Relacionada, TCC.Cod_Busca, TCC.Campo_Exibicao, 
                      CP.Num_Proc
FROM         dbo.Tipo_Campo_Cliente AS TCC WITH (nolock) LEFT OUTER JOIN
                      dbo.Campo_Processo AS CP WITH (nolock) ON TCC.Id_Campo = CP.Id_Campo AND CP.Num_Proc = CP.Num_Proc INNER JOIN
                      dbo.vwCliente AS C ON CP.Num_Proc = C.num_proc LEFT OUTER JOIN
                      dbo.Pessoa_LLP AS PPL WITH (nolock) ON PPL.Cd_Pes = C.cd_cliente LEFT OUTER JOIN
                      dbo.Grupo AS GRP WITH (nolock) ON GRP.Cd_Pes_Grupo = PPL.Cd_Pes_Grupo INNER JOIN
                      dbo.Tipo_Campo_Cliente_Modais AS M WITH (nolock) ON M.Id_Campo = TCC.Id_Campo
WHERE     (TCC.Cd_Pes_Grupo IN ('10017', GRP.Cd_Pes_Grupo)) AND (TCC.Tipo <> 'X') AND (LEN(CP.Num_Proc) = 16) AND (M.House = 1) AND (LEFT(CP.Num_Proc, 1) = 'E') AND 
                      (M.Export = '1') AND (SUBSTRING(CP.Num_Proc, 2, 1) = 'A') AND (M.Air = '1') OR
                      (TCC.Cd_Pes_Grupo IN ('10017', GRP.Cd_Pes_Grupo)) AND (TCC.Tipo <> 'X') AND (LEN(CP.Num_Proc) = 14) AND (LEFT(CP.Num_Proc, 1) = 'E') AND (M.Export = '1') AND
                       (SUBSTRING(CP.Num_Proc, 2, 1) = 'A') AND (M.Air = '1') AND (M.Master = 1) OR
                      (TCC.Cd_Pes_Grupo IN ('10017', GRP.Cd_Pes_Grupo)) AND (TCC.Tipo <> 'X') AND (LEN(CP.Num_Proc) = 16) AND (M.House = 1) AND (LEFT(CP.Num_Proc, 1) = 'I') AND 
                      (SUBSTRING(CP.Num_Proc, 2, 1) = 'A') AND (M.Air = '1') AND (M.Import = '1') OR
                      (TCC.Cd_Pes_Grupo IN ('10017', GRP.Cd_Pes_Grupo)) AND (TCC.Tipo <> 'X') AND (LEN(CP.Num_Proc) = 14) AND (LEFT(CP.Num_Proc, 1) = 'I') AND 
                      (SUBSTRING(CP.Num_Proc, 2, 1) = 'A') AND (M.Air = '1') AND (M.Master = 1) AND (M.Import = '1') OR
                      (TCC.Cd_Pes_Grupo IN ('10017', GRP.Cd_Pes_Grupo)) AND (TCC.Tipo <> 'X') AND (LEN(CP.Num_Proc) = 16) AND (M.House = 1) AND (LEFT(CP.Num_Proc, 1) = 'E') AND 
                      (M.Export = '1') AND (SUBSTRING(CP.Num_Proc, 2, 1) = 'M') AND (M.Ocean = '1') OR
                      (TCC.Cd_Pes_Grupo IN ('10017', GRP.Cd_Pes_Grupo)) AND (TCC.Tipo <> 'X') AND (LEN(CP.Num_Proc) = 14) AND (LEFT(CP.Num_Proc, 1) = 'E') AND (M.Export = '1') AND
                       (SUBSTRING(CP.Num_Proc, 2, 1) = 'M') AND (M.Master = 1) AND (M.Ocean = '1') OR
                      (TCC.Cd_Pes_Grupo IN ('10017', GRP.Cd_Pes_Grupo)) AND (TCC.Tipo <> 'X') AND (LEN(CP.Num_Proc) = 16) AND (M.House = 1) AND (LEFT(CP.Num_Proc, 1) = 'I') AND 
                      (SUBSTRING(CP.Num_Proc, 2, 1) = 'M') AND (M.Import = '1') AND (M.Ocean = '1') OR
                      (TCC.Cd_Pes_Grupo IN ('10017', GRP.Cd_Pes_Grupo)) AND (TCC.Tipo <> 'X') AND (LEN(CP.Num_Proc) = 14) AND (LEFT(CP.Num_Proc, 1) = 'I') AND 
                      (SUBSTRING(CP.Num_Proc, 2, 1) = 'M') AND (M.Master = 1) AND (M.Import = '1') AND (M.Ocean = '1') OR
                      (TCC.Cd_Pes_Grupo IN ('10017', GRP.Cd_Pes_Grupo)) AND (TCC.Tipo <> 'X') AND (LEN(CP.Num_Proc) = 16) AND (M.House = 1) AND (LEFT(CP.Num_Proc, 1) = 'E') AND 
                      (M.Export = '1') AND (SUBSTRING(CP.Num_Proc, 2, 1) = 'O') AND (M.Other = '1') OR
                      (TCC.Cd_Pes_Grupo IN ('10017', GRP.Cd_Pes_Grupo)) AND (TCC.Tipo <> 'X') AND (LEN(CP.Num_Proc) = 14) AND (LEFT(CP.Num_Proc, 1) = 'E') AND (M.Export = '1') AND
                       (SUBSTRING(CP.Num_Proc, 2, 1) = 'O') AND (M.Master = 1) AND (M.Other = '1') OR
                      (TCC.Cd_Pes_Grupo IN ('10017', GRP.Cd_Pes_Grupo)) AND (TCC.Tipo <> 'X') AND (LEN(CP.Num_Proc) = 16) AND (M.House = 1) AND (LEFT(CP.Num_Proc, 1) = 'I') AND 
                      (SUBSTRING(CP.Num_Proc, 2, 1) = 'O') AND (M.Import = '1') AND (M.Other = '1') OR
                      (TCC.Cd_Pes_Grupo IN ('10017', GRP.Cd_Pes_Grupo)) AND (TCC.Tipo <> 'X') AND (LEN(CP.Num_Proc) = 14) AND (LEFT(CP.Num_Proc, 1) = 'I') AND 
                      (SUBSTRING(CP.Num_Proc, 2, 1) = 'O') AND (M.Master = 1) AND (M.Import = '1') AND (M.Other = '1')

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
         Begin Table = "TCC"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 200
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CP"
            Begin Extent = 
               Top = 6
               Left = 238
               Bottom = 114
               Right = 389
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "M"
            Begin Extent = 
               Top = 6
               Left = 427
               Bottom = 114
               Right = 578
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 6
               Left = 616
               Bottom = 114
               Right = 767
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PPL"
            Begin Extent = 
               Top = 6
               Left = 805
               Bottom = 114
               Right = 956
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "GRP"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 189
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
      Begin ColumnWidths = 20
         Column = 1440
         Alias = 900
         Table = 1170
    ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCampoCliente'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'     Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCampoCliente'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCampoCliente'
GO
