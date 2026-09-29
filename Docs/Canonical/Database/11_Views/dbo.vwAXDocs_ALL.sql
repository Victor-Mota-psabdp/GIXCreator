SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW dbo.vwAXDocs_ALL
AS
SELECT DISTINCT NumeroInternoAX, num_proc, cd_tp_tx_Atl, dc, I.id_Ax, I.TaxGroup Tax_Group,CASE WHEN tipo = 2 THEN I.Num_Proc + '.' + Invoice_number + RTRIM(I.DC) 
                      + '.' + I.Cd_Tp_TX_ATL WHEN len(Invoice_number) = 15 AND tipo <> 2 THEN I.Num_Proc + '.' + isnull(Cod_Int_Moeda, 0) + cast(H.ID_AX AS varchar(50)) + RTRIM(I.DC) 
                      + '.' + I.Cd_Tp_TX_ATL WHEN Tipo = 3 THEN Invoice_number + '.' + isnull(Cod_Int_Moeda, 0) + RTRIM(I.DC) 
                      + '.' + I.Cd_Tp_TX_ATL + '_ADV' ELSE Invoice_number + '.' + isnull(Cod_Int_Moeda, 0) + RTRIM(I.DC) 
                      + '.' + I.Cd_Tp_TX_ATL /*				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL */ END Invoice_AX , dt_canc

FROM         Ax_Doc_ITem I WITH (nolock) JOIN
                      Ax_Doc H WITH (nolock) ON I.id_Ax = H.id_ax
                      Join Tipo_Moeda TM ON TM.cd_tp_moeda = Moeda
WHERE      len(isnull(NumeroInternoAX, '1')) <> 14
UNION ALL
SELECT DISTINCT NumeroInternoAX, NumeroInternoAX, cd_tp_tx_Atl, dc, I.id_Ax, I.TaxGroup Tax_Group,CASE WHEN tipo = 2 THEN I.Num_Proc + '.' + Invoice_number + RTRIM(I.DC) 
                      + '.' + I.Cd_Tp_TX_ATL WHEN len(Invoice_number) = 15 AND tipo <> 2 THEN I.Num_Proc + '.' + isnull(Cod_Int_Moeda, 0) + cast(H.ID_AX AS varchar(50)) + RTRIM(I.DC) 
                      + '.' + I.Cd_Tp_TX_ATL WHEN Tipo = 3 THEN Invoice_number + '.' + isnull(Cod_Int_Moeda, 0) + RTRIM(I.DC) 
                      + '.' + I.Cd_Tp_TX_ATL + '_ADV' ELSE Invoice_number + '.' + isnull(Cod_Int_Moeda, 0) + RTRIM(I.DC) 
                      + '.' + I.Cd_Tp_TX_ATL /*				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL */ END Invoice_AX, dt_canc
FROM         Ax_Doc_ITem I WITH (nolock) JOIN
                      Ax_Doc H WITH (nolock) ON I.id_Ax = H.id_ax
                      Join Tipo_Moeda TM ON TM.cd_tp_moeda = Moeda
WHERE     len(isnull(NumeroInternoAX, '1')) = 14
UNION ALL
SELECT DISTINCT LEFT(Invoice_Number, 14) NumeroInternoAX, LEFT(Invoice_Number, 14) NumeroInternoAX, cd_tp_tx_Atl, dc, I.id_Ax, I.TaxGroup Tax_Group,CASE WHEN tipo = 2 THEN I.Num_Proc + '.' + Invoice_number + RTRIM(I.DC) 
                      + '.' + I.Cd_Tp_TX_ATL WHEN len(Invoice_number) = 15 AND tipo <> 2 THEN I.Num_Proc + '.' + isnull(Cod_Int_Moeda, 0) + cast(H.ID_AX AS varchar(50)) + RTRIM(I.DC) 
                      + '.' + I.Cd_Tp_TX_ATL WHEN Tipo = 3 THEN Invoice_number + '.' + isnull(Cod_Int_Moeda, 0) + RTRIM(I.DC) 
                      + '.' + I.Cd_Tp_TX_ATL + '_ADV' ELSE Invoice_number + '.' + isnull(Cod_Int_Moeda, 0) + RTRIM(I.DC) 
                      + '.' + I.Cd_Tp_TX_ATL /*				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL */ END Invoice_AX, dt_canc
FROM         Ax_Doc_ITem I WITH (nolock) JOIN
                      Ax_Doc H WITH (nolock) ON I.id_Ax = H.id_ax
                      Join Tipo_Moeda TM ON TM.cd_tp_moeda = Moeda
WHERE      len(isnull(Invoice_Number, '1')) = 15

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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwAXDocs_ALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwAXDocs_ALL'
GO
