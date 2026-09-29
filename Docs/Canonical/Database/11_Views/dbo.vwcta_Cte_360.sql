SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwcta_Cte_360]
WITH SCHEMABINDING 
AS
SELECT     Cd_Cred_Dev_HIA, Num_Proc_HIA, Cd_Tp_Tx, DC_HIA, Dt_Ins_HIA, Cd_Tp_Moeda, Vlr_Org_HIA, Desp_Org_HIA, Num_NF_HIA, Val_Con_Comp, Ref_Acesso_NF_HIA, 
                      Vlr_Pgto_NF_HIA, Par_NF_HIA, dt_prev_pgto_hia
FROM         dbo.Cta_Cte_Hou_Imp_Aer WITH (nolock)
WHERE     convert(Datetime,Dt_Ins_HIA,105) >= GETDATE() - 360
UNION ALL
SELECT     Cd_Cred_Dev_MIA, Num_Proc_MIA, Cd_Tp_Tx, DC_MIA, Dt_Ins_MIA, Cd_Tp_Moeda, Vlr_Org_MIA, Desp_Org_MIA, Num_NF_MIA, Val_Con_Comp, 
                      Ref_Acesso_NF_MIA, Vlr_Pgto_NF_MIA, Par_NF_MIA, dt_prev_pgto_mia
FROM         dbo.Cta_Cte_Mas_Imp_Aer WITH (nolock)
WHERE    convert(Datetime, Dt_Ins_MIA,105) >= GETDATE() - 360
UNION ALL
SELECT     Cd_Cred_Dev_HEA, Num_Proc_HEA, Cd_Tp_Tx, DC_HEA, Dt_Ins_HEA, Cd_Tp_Moeda, Vlr_Org_HEA, Desp_Dst_HEA, Num_NF_HEA, Val_Con_Comp, 
                      Ref_Acesso_NF_HEA, Vlr_Pgto_NF_HEA, Par_NF_HEA, dt_prev_pgto_hEa
FROM         dbo.Cta_Cte_Hou_Exp_Aer WITH (nolock)
WHERE     convert(Datetime,Dt_Ins_HEA,105) >= GETDATE() - 360
UNION
SELECT     Cd_Cred_Dev_MEA, Num_Proc_MEA, Cd_Tp_Tx, DC_MEA, Dt_Ins_MEA, Cd_Tp_Moeda, Vlr_Org_MEA, Desp_Dst_MEA, Num_NF_MEA, Val_Con_Comp, 
                      Ref_Acesso_NF_MEA, Vlr_Pgto_NF_MEA, Par_NF_MEA, dt_prev_pgto_MEa
FROM         dbo.Cta_Cte_Mas_Exp_Aer WITH (nolock)
WHERE     convert(Datetime,Dt_Ins_MEA,105) >= GETDATE() - 360
UNION ALL
SELECT     Cd_Cred_Dev_HIM, Num_Proc_HIM, Cd_Tp_Tx, DC_HIM, Dt_Ins_HIM, Cd_Tp_Moeda, Vlr_Org_HIM, Desp_Org_HIM, Num_NF_HIM, Val_Con_Comp, 
                      Ref_Acesso_NF_HIM, Vlr_Pgto_NF_HIM, Par_NF_HIM, dt_prev_pgto_hiM
FROM         dbo.Cta_Cte_Hou_Imp_Mar WITH (nolock)
WHERE     convert(Datetime,Dt_Ins_HIM,105) >= GETDATE() - 360
UNION
SELECT     Cd_Cred_Dev_MIM, Num_Proc_MIM, Cd_Tp_Tx, DC_MIM, Dt_Ins_MIM, Cd_Tp_Moeda, Vlr_Org_MIM, Desp_Org_MIM, Num_NF_MIM, Val_Con_Comp, 
                      Ref_Acesso_NF_MIM, Vlr_Pgto_NF_MIM, Par_NF_MIM, dt_prev_pgto_MIM
FROM         dbo.Cta_Cte_Mas_Imp_Mar
WHERE    convert(Datetime, Dt_Ins_MIM,105) >= GETDATE() - 360
UNION ALL
SELECT     Cd_Cred_Dev_HEM, Num_Proc_HEM, Cd_Tp_Tx, DC_HEM, Dt_Ins_HEM, Cd_Tp_Moeda, Vlr_Org_HEM, Desp_Dst_HEM, Num_NF_HEM, Val_Con_Comp, 
                      Ref_Acesso_NF_HEM, Vlr_Pgto_NF_HEM, Par_NF_HEM, dt_prev_pgto_hEM
FROM         dbo.Cta_Cte_Hou_Exp_Mar WITH (nolock)
WHERE     convert(Datetime,Dt_Ins_HEM,105) >= GETDATE() - 360
UNION ALL
SELECT     Cd_Cred_Dev_MEM, Num_Proc_MEM, Cd_Tp_Tx, DC_MEM, Dt_Ins_MEM, Cd_Tp_Moeda, Vlr_Org_MEM, Desp_Dst_MEM, Num_NF_MEM, Val_Con_Comp, 
                      Ref_Acesso_NF_MEM, Vlr_Pgto_NF_MEM, Par_NF_MEM, dt_prev_pgto_MEM
FROM         dbo.Cta_Cte_Mas_Exp_Mar WITH (nolock)
WHERE     convert(Datetime,Dt_Ins_MEM,105) >= GETDATE() - 360
UNION ALL
SELECT     Cd_Cred_Dev_HEO, Num_Proc_HEO, Cd_Tp_Tx, DC_HEO, Dt_Ins_HEO, Cd_Tp_Moeda, Vlr_Org_HEO, Desp_Org_HEO, Num_NF_HEO, Val_Con_Comp, 
                      Ref_Acesso_NF_HEO, Vlr_Pgto_NF_HEO, Par_NF_HEO, dt_prev_pgto_hEO
FROM         dbo.Cta_Cte_Hou_Exp_Out WITH (nolock)
WHERE     convert(Datetime,Dt_Ins_HEO,105) >= GETDATE() - 360
UNION ALL
SELECT     Cd_Cred_Dev_HIO, Num_Proc_HIO, Cd_Tp_Tx, DC_HIO, Dt_Ins_HIO, Cd_Tp_Moeda, Vlr_Org_HIO, Desp_Org_HIO, Num_NF_HIO, Val_Con_Comp, 
                      Ref_Acesso_NF_HIO, Vlr_Pgto_NF_HIO, Par_NF_HIO, dt_prev_pgto_hiO
FROM         dbo.Cta_Cte_Hou_Imp_Out WITH (nolock)
WHERE    convert(Datetime, Dt_Ins_HIO,105) >= GETDATE() - 360


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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwcta_Cte_360'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwcta_Cte_360'
GO
