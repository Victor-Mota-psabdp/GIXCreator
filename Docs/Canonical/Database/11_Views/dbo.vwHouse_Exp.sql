SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwHouse_Exp]
AS
SELECT     LLP.Num_Proc_LEM[Num_Proc], HOU.Dt_Emis_HEM[Dt_Emis], 'Ocean Export' [Modal], LLP.PO_Req_Date[PO_Req_Date], LLP.ATA_LEM[ATA], LLP.ATD_LEM[ATD], 
                      LLP.Canal_LEM[Canal], LLP.ETA_LEM[ETA], LLP.ETD_LEM[ETD], LLP.Original_ETA_LEM[Original_ETA], LLP.ID_Status[ID_Status], HOU.Cd_Export_HEM[Cd_Export], 
                      LLP.Banco, HOU.Cd_Consig_HEM[Cd_Consig], HOU.Cd_Org_HEM[Cd_Org], HOU.Cd_Dst_HEM[Cd_Dst], HOU.Navio_HEM[Vessel], 
                      HOU.Peso_Bruto_HEM[Peso_Bruto], HOU.Peso_Liquido_HEM[Peso_Liquido], NULL [Peso_Cubado], LLP.Cd_Armador_Lem[Cd_Armador], 
                      JOB.Nr_Reserva[Booking_Number], LLP.DL_Draft_Lem[Dead_line], LLP.DL_Cargo_Lem[Cut_Date], LLP.Cd_Tp_Carga[Cd_Tp_Carga], HOU.Cd_Tp_Oper, 
                      Intl_Ref_Lem Intl_Ref, HOU.MAWB_HEM MAWB, HAWB_HEM HAWB, LLP.Vlr_Invoice[Vlr_Invoice], LLP.Cd_Moeda_Invoice[Moeda_invoice], 
                      HOU.Num_Proc_MEM[Master], HOU.Cd_Tp_Moeda[Moeda_Frete], CASE WHEN HOU.Tp_Frete_HEM = 'P' THEN 'Prepaid' ELSE 'Collect' END [Tipo_Frete], 
                      HOU.Vlr_Frete_Tot_HEM[Frete_BL], HOU.Obs_HEM[Notas], Cd_Usuario, LLP.DL_VGM_LEM[DL_VGM], HOU.Viagem_HEM[Viagem], LLP.Cd_Planta_Lem[cd_planta], 
                      LLP.Cd_DstFinal_Lem[Cd_DstFinal], HOU.Qtd_Tot_Vol_HEM[Qtd_Vol], Cd_Terminal, Cd_Agente, LLP.Cd_Transportadora, LLP.Cd_Forwarder, 
                      HOU.Vol_Tot_HEM[Vol_Tot], JOB.Cd_Vendedor, HOU.Cd_Notify_HEM[Cd_Notify], LLP.ID_Viagem[ID_Viagem]
                      ,   NULL [Tipo_Others]
FROM         LLP_Exp_Mar LLP WITH (nolock) JOIN
                      House_Exp_Mar HOU WITH (nolock) ON LLP.Num_Proc_LEM = HOU.Num_Proc_HEM LEFT OUTER JOIN
                      Job_Exp_Mar JOB WITH (nolock) ON HOU.Num_Proc_HEM = JOB.Num_Proc_HEM
UNION ALL
SELECT     LLP.Num_Proc_LEA[Num_Proc], HOU.Dt_Emis_HEA[Dt_Emis], 'Air Export' [Modal], LLP.PO_Req_Date[PO_Req_Date], LLP.ATA_LEA[ATA], LLP.ATD_LEA[ATD], 
                      LLP.Canal_LEA[Canal], LLP.ETA_LEA[ETA], LLP.ETD_LEA[ETD], LLP.Original_ETA_LEA[Original_ETA], LLP.ID_Status[ID_Status], HOU.Cd_Export_HEA[Cd_Export], 
                      LLP.Banco, HOU.Cd_Consig_HEA[Cd_Consig], HOU.Cd_Org_HEA[Cd_Org], HOU.Cd_Dst_HEA[Cd_Dst], HOU.Voo_HEA[Vessel], HOU.Peso_Bruto_HEA[Peso_Bruto], 
                      HOU.Peso_Real_HEA[Peso_Liquido], LLP.Peso_Cubado_Lea[Peso_Cubado], LLP.Cd_CiaAerea_Lea[Cd_Armador], NULL [Booking_Number], NULL [Dead_line], 
                      LLP.DL_Cargo_LEA[Cut_Date], NULL [Cd_Tp_Carga], HOU.Cd_Tp_Oper, Intl_Ref_LeA Intl_Ref, HOU.MAWB_HEA[MAWB], HAWB_HEA[HAWB], 
                      LLP.Vlr_Invoice[Vlr_Invoice], LLP.Cd_Moeda_Invoice[Moeda_invoice], HOU.Num_Proc_MEA[Master], HOU.Cd_Tp_Moeda[Moeda_Frete], 
                      CASE WHEN HOU.Tp_Frete_HEA = 'P' THEN 'Prepaid' ELSE 'Collect' END [Tipo_Frete], HOU.Vlr_Frete_Tot_HEA[Frete_BL], HOU.Obs_HEA[Notas], Cd_Usuario, NULL 
                      [ DL_VGM], NULL [Viagem], LLP.Cd_Planta_Lea[cd_planta], LLP.cd_dstfinal_LEA[Cd_DstFinal], HOU.Qtd_Tot_Vol_HEA[Qtd_Vol], Cd_Terminal, Cd_Agente, 
                      LLP.Cd_Transportadora, LLP.Cd_Forwarder, HOU.Vol_Tot_HEA[Vol_Tot], JOB.Cd_Vendedor, HOU.Cd_Notify_HEA[Cd_Notify],NULL[ID_Viagem]
                      ,NULL [Tipo_Others]
FROM         LLP_Exp_Aer LLP WITH (nolock) JOIN
                      House_Exp_Aer HOU WITH (nolock) ON LLP.Num_Proc_LEA = HOU.Num_Proc_HEA LEFT JOIN
                      Job_Exp_Aer JOB WITH (nolock) ON HOU.Num_Proc_HEA = JOB.Num_Proc_HEA
UNION ALL
SELECT     LLP.Num_Proc_LEO[Num_Proc], HOU.Dt_Emis_HEO[Dt_Emis], 'Other Export' [Modal], LLP.PO_Req_Date[PO_Req_Date], LLP.ATA_LEO[ATA], LLP.ATD_LEO[ATD], 
                      LLP.Canal_LEO[Canal], LLP.ETA_LEO[ETA], LLP.ETD_LEO[ETD], LLP.Original_ETA_LEO[Original_ETA], LLP.ID_Status[ID_Status], HOU.Cd_Export_HEO[Cd_Export], 
                      LLP.Banco, HOU.Cd_Consig_HEO[Cd_Consig], HOU.Cd_Org_HEO[Cd_Org], HOU.Cd_Dst_HEO[Cd_Dst], NULL [Vessel], HOU.Peso_Bruto_HEO[Peso_Bruto], 
                      HOU.Peso_Real_HEO[Peso_Liquido], LLP.Peso_Cubado_LEO[Peso_Cubado], LLP.Cd_Carrier[Cd_Armador], NULL [Booking_Number], NULL [Dead_line], 
                      LLP.DL_Cargo_Leo[Cut_Date], NULL [Cd_Tp_Carga], HOU.Cd_Tp_Oper, Intl_Ref_Leo Intl_Ref, MAWB_HEO MAWB, HAWB_HEO HAWB, LLP.Vlr_Invoice[Vlr_Invoice], 
                      LLP.Cd_Moeda_Invoice[Moeda_invoice], NULL [Master], HOU.Cd_Tp_Moeda[Moeda_Frete], 
                      CASE WHEN HOU.Tp_Frete_HEO = 'P' THEN 'Prepaid' ELSE 'Collect' END [Tipo_Frete], HOU.Vlr_Frete_Efet_HEO[Frete_BL], HOU.Obs_HEO[Notas], Cd_Usuario, NULL 
                      [ DL_VGM], NULL [Viagem], LLP.Cd_Planta_Leo[cd_planta], LLP.Cd_DstFinal_Leo[Cd_DstFinal], HOU.Qtd_Tot_Vol_HEO[Qtd_Vol], Cd_Terminal, Cd_Agente, 
                      LLP.Cd_Transportadora, LLP.Cd_Forwarder, HOU.Vol_Tot_HEO[Vol_Tot], LLP.Cd_Vendedor, HOU.Cd_Notify_HEO[Cd_Notify],NULL[ID_Viagem]
                      ,LLP.Tipo_Leo[Tipo_Others]
FROM         LLP_Exp_Out LLP WITH (nolock) JOIN
                      House_Exp_Out HOU WITH (nolock) ON LLP.Num_Proc_LEO = HOU.Num_Proc_HEO


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
         Top = -192
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwHouse_Exp'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwHouse_Exp'
GO
