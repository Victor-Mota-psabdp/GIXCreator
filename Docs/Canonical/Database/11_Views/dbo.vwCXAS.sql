SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwCXAS]
AS
SELECT     Num_Proc_HIA, Vlr_Pgto_Rcto_HIA, Num_Lcto, DC_HIA, Cd_Tp_Tx, Num_Rcb_HIA, Dt_Pgto_Rcto_HIA, Vlr_Ref_HIA
FROM         dbo.Caixa_Hou_Imp_Aer WITH (nolock)
WHERE     (Num_Lcto <> 'PROVISÓRIO')
UNION ALL
SELECT     Num_Proc_MIA, Vlr_Pgto_Rcto_MIA, Num_Lcto, DC_MIA, Cd_Tp_Tx, Num_Rcb_MIA, Dt_Pgto_Rcto_MIA, Vlr_Ref_MIA
FROM         dbo.Caixa_Mas_Imp_Aer WITH (nolock)
WHERE     (Num_Lcto <> 'PROVISÓRIO')
UNION ALL
SELECT     Num_Proc_HEA, Vlr_Pgto_Rcto_HEA, Num_Lcto, DC_HEA, Cd_Tp_Tx, Num_Rcb_HEA, Dt_Pgto_Rcto_HEA, Vlr_Ref_HEA
FROM         dbo.Caixa_Hou_Exp_Aer WITH (nolock)
WHERE     (Num_Lcto <> 'PROVISÓRIO')
UNION ALL
SELECT     Num_Proc_MEA, Vlr_Pgto_Rcto_MEA, Num_Lcto, DC_MEA, Cd_Tp_Tx, Num_Rcb_MEA, Dt_Pgto_Rcto_MEA, Vlr_Ref_MEA
FROM         dbo.Caixa_Mas_Exp_Aer WITH (nolock)
WHERE     (Num_Lcto <> 'PROVISÓRIO')
UNION ALL
SELECT     Num_Proc_HIM, Vlr_Pgto_Rcto_HIM, Num_Lcto, DC_HIM, Cd_Tp_Tx, Num_Rcb_HIM, Dt_Pgto_Rcto_HIM, Vlr_Ref_HIM
FROM         dbo.Caixa_Hou_Imp_Mar WITH (nolock)
WHERE     (Num_Lcto <> 'PROVISÓRIO')
UNION ALL
SELECT     Num_Proc_MIM, Vlr_Pgto_Rcto_MIM, Num_Lcto, DC_MIM, Cd_Tp_Tx, Num_Rcb_MIM, Dt_Pgto_Rcto_MIM, Vlr_Ref_MIM
FROM         dbo.Caixa_Mas_Imp_Mar WITH (nolock)
WHERE     (Num_Lcto <> 'PROVISÓRIO')
UNION ALL
SELECT     Num_Proc_HEM, Vlr_Pgto_Rcto_HEM, Num_Lcto, DC_HEM, Cd_Tp_Tx, Num_Rcb_HEM, Dt_Pgto_Rcto_HEM, Vlr_Ref_HEM
FROM         dbo.Caixa_Hou_Exp_Mar WITH (nolock)
WHERE     (Num_Lcto <> 'PROVISÓRIO')
UNION ALL
SELECT     Num_Proc_MEM, Vlr_Pgto_Rcto_MEM, Num_Lcto, DC_MEM, Cd_Tp_Tx, Num_Rcb_MEM, Dt_Pgto_Rcto_MEM, Vlr_Ref_MEM
FROM         dbo.Caixa_Mas_Exp_Mar WITH (nolock)
WHERE     (Num_Lcto <> 'PROVISÓRIO')
UNION ALL
SELECT     Num_Proc_HEO, Vlr_Pgto_Rcto_HEO, Num_Lcto, DC_HEO, Cd_Tp_Tx, Num_Rcb_HEO, Dt_Pgto_Rcto_HEO, Vlr_Ref_HEO
FROM         dbo.Caixa_Hou_Exp_Out WITH (nolock)
WHERE     (Num_Lcto <> 'PROVISÓRIO')
UNION ALL
SELECT     Num_Proc_HIO, Vlr_Pgto_Rcto_HIO, Num_Lcto, DC_HIO, Cd_Tp_Tx, Num_Rcb_HIO, Dt_Pgto_Rcto_HIO, Vlr_Ref_HIO
FROM         dbo.Caixa_Hou_Imp_Out WITH (nolock)
WHERE     (Num_Lcto <> 'PROVISÓRIO')
UNION ALL
SELECT     Num_Proc, Vlr_Pgto_Rcto, Num_Lcto, DC, Cd_Tp_Tx, NULL, CONVERT(varchar(10), Dt_Pgto_Rcto, 103) Dt_Pgto_Rcto, Vlr_Ref
FROM         dbo.Caixa_AX WITH (nolock)
WHERE     status = 1
UNION ALL
SELECT     Num_Proc_HBO, Vlr_Pgto_Rcto_HBO, Num_Lcto, DC_HBO, Cd_Tp_Tx, Num_Rcb_HBO, Dt_Pgto_Rcto_HBO, Vlr_Ref_HBO
FROM         dbo.Caixa_Hou_BDP_Out WITH (nolock)
WHERE     (Num_Lcto <> 'PROVISÓRIO')


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
         Configuration = "(H (4[30] 2[40] 3) )"
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
      ActivePaneConfig = 3
   End
   Begin DiagramPane = 
      PaneHidden = 
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCXAS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCXAS'
GO
