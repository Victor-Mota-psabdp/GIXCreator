SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwHouse_Imp_KHDA_RL]
AS
SELECT     LLP.Num_Proc_Lim[Num_Proc], HOU.Dt_Emis_Him[Dt_Emis], 'Ocean Import' [Modal], HOU.Obs_HIM [Notas], HOU.MAWB_HIM [MAWB] ,LLP.PO_Req_Date[PO_Req_Date], LLP.ATA_Lim[ATA], LLP.ATD_lim[ATD], 
                      LLP.Canal_Lim[Canal], LLP.ETA_Lim[ETA], LLP.ETD_Lim[ETD], LLP.Original_ETA_LIM[Original_ETA], LLP.ID_Status[ID_Status], HOU.Cd_Export_HIM[Cd_Export], 
                      LLP.Banco, HOU.Cd_Consig_HIM[Cd_Consig], HOU.Cd_Org_HIM[Cd_Org], HOU.Cd_Dst_HIM[Cd_Dst],
					  HOU.Navio_HIM[Vessel], HOU.Peso_Bruto_HIM[Peso_Bruto], HOU.Peso_Liquido_HIM[Peso_Liquido], JOB.Cd_Armador[Cd_Armador],
                      LLP.Cd_Planta_Lim[Cd_Planta], TC.Nome_Tp_Carga [Tp_Carga],LLP.Cd_DstFinal_Lim[Cd_DstFinal], HOU.[Cd_Tp_Oper], LLP.Cd_Terminal [Cd_Terminal],HOU.HAWB_HIM [HAWB]
FROM         LLP_Imp_Mar LLP WITH (nolock) JOIN
                      House_IMP_Mar HOU WITH (nolock) ON LLP.Num_Proc_LIM = HOU.Num_Proc_HIM LEFT JOIN
                      Job_Imp_Mar JOB WITH (nolock) ON HOU.Num_Proc_HIM = JOB.Num_Proc_HIM LEFT JOIN
                      Tipo_Carga TC WITH (nolock) ON LLP.Cd_Tp_Carga = TC.Cd_Tp_Carga 
UNION ALL
SELECT     LLP.Num_Proc_LIA[Num_Proc], HOU.Dt_Emis_HIA[Dt_Emis], 'Air Import' [Modal], HOU.Obs_HIA [Notas], HOU.MAWB_HIA [MAWB] ,LLP.PO_Req_Date[PO_Req_Date], LLP.ATA_LIA[ATA], LLP.ATD_LIA[ATD], 
                      LLP.Canal_LIA[Canal], LLP.ETA_LIA[ETA], LLP.ETD_LIA[ETD], LLP.Original_ETA_LIA[Original_ETA], LLP.ID_Status[ID_Status], HOU.Cd_Export_HIA[Cd_Export], 
                      LLP.Banco, HOU.Cd_Consig_HIA[Cd_Consig], HOU.Cd_Org_HIA[Cd_Org], HOU.Cd_Dst_HIA[Cd_Dst],
                      HOU.Voo_HIA[Vessel], HOU.Peso_Bruto_HIA[Peso_Bruto],HOU.Peso_Real_HIA[Peso_Liquido], JOB.Cd_Cia_Aer[Cd_Armador], 
                      LLP.Cd_Planta_Lia[Cd_Planta], 'Air' [Tp_Carga], LLP.Cd_DstFinal_Lia[Cd_DstFinal], HOU.[Cd_Tp_Oper], LLP.Cd_Terminal [Cd_Terminal],HOU.HAWB_HIA [HAWB]
FROM         LLP_Imp_Aer LLP WITH (nolock) JOIN
                      House_Imp_Aer HOU WITH (nolock) ON LLP.Num_Proc_LIA = HOU.Num_Proc_HIA LEFT JOIN
                      Job_Imp_Aer JOB WITH (nolock) ON HOU.Num_Proc_HIA = JOB.Num_Proc_HIA
UNION ALL
SELECT     LLP.Num_Proc_LIO[Num_Proc], HOU.Dt_Emis_HIO[Dt_Emis], 'Other Import' [Modal], HOU.Obs_HIO [Notas,], HOU.MAWB_HIO [MAWB] ,LLP.PO_Req_Date[PO_Req_Date], LLP.ATA_LIO[ATA], LLP.ATD_LIO[ATD], 
                      LLP.Canal_LIO[Canal], LLP.ETA_LIO[ETA], LLP.ETD_LIO[ETD], LLP.Original_ETA_LIO[Original_ETA], LLP.ID_Status[ID_Status], HOU.Cd_Export_HIO[Cd_Export], 
                      LLP.Banco, HOU.Cd_Consig_HIO[Cd_Consig], HOU.Cd_Org_HIO[Cd_Org], HOU.Cd_Dst_HIO[Cd_Dst],
                      '' [Vessel], HOU.Peso_Bruto_HIO[Peso_Bruto], HOU.Peso_Real_HIO[Peso_Liquido],LLP.Cd_Carrier[Cd_Armador], 
                      LLP.Cd_Planta_Lio[Cd_Planta], CASE WHEN LLP.Tipo_Lio = 'T' THEN 'Truck' ELSE 'Rail' END [Tp_Carga], LLP.Cd_DstFinal_Lio[Cd_DstFinal], HOU.[Cd_Tp_Oper], LLP.Cd_Terminal [Cd_Terminal],HOU.HAWB_HIO [HAWB]
FROM         LLP_Imp_Out LLP WITH (nolock) JOIN
                      House_Imp_Out HOU WITH (nolock) ON LLP.Num_Proc_Lio = HOU.Num_Proc_HIO
                      
                      



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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwHouse_Imp_KHDA_RL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwHouse_Imp_KHDA_RL'
GO
