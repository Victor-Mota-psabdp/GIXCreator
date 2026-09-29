SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwCliente]
AS
SELECT     Dt_emis_hem Dt_Criacao, Num_Proc_HEM AS num_proc, Cd_Export_HEM AS cd_cliente, ETD_LEM DATA, Num_proc_mem Master
FROM         dbo.House_Exp_Mar WITH (nolock) JOIN
                      LLP_Exp_mar LLP WITH (nolock)  ON llp.num_proc_lem = num_proc_hem
UNION ALL
SELECT     Dt_emis_heo Dt_Criacao, Num_Proc_HEO AS num_proc, Cd_Export_HEO, ETD_LEO DATA, 'JOB' Master
FROM         dbo.House_Exp_Out WITH (nolock) JOIN
                      LLP_Exp_out LLP WITH (nolock)  ON llp.num_proc_leo = num_proc_heo
UNION ALL
SELECT     Dt_emis_hea Dt_Criacao, Num_Proc_HEA AS num_proc, Cd_Export_HEA, ETD_LEA DATA, Num_proc_meA Master
FROM         dbo.House_Exp_Aer WITH (nolock) JOIN
                      LLP_Exp_aer LLP ON llp.num_proc_lea = num_proc_hea
UNION ALL
SELECT     Dt_emis_him Dt_Criacao, Num_Proc_HIM AS num_proc, Cd_Consig_HIM, eta_LIM DATA, Num_proc_mIM Master
FROM         dbo.House_Imp_Mar WITH (nolock) JOIN
                      LLP_Imp_MAr LLP WITH (nolock)  ON llp.num_proc_lim = num_proc_him
UNION ALL
SELECT     Dt_emis_hia Dt_Criacao, Num_Proc_HIA AS num_proc, Cd_Consig_HIA, eta_lia DATA, Num_proc_mIA Master
FROM         dbo.House_Imp_Aer WITH (nolock) JOIN
                      LLP_Imp_Aer LLP WITH (nolock)  ON llp.num_proc_lia = num_proc_hia
UNION ALL
SELECT     Dt_emis_hio Dt_Criacao, Num_Proc_HIO AS num_proc, Cd_Consig_HIO, eta_LIO DATA, 'JOB' Master
FROM         dbo.House_Imp_Out WITH (nolock) JOIN
                      LLP_imp_out LLP WITH (nolock)  ON llp.num_proc_lio = num_proc_hio
                      
UNION ALL
SELECT     Dt_emis_hbo Dt_Criacao, Num_Proc_HBO AS num_proc, cd_cliente_hbo, null DATA, 'JOB' Master
FROM         dbo.House_BDP_OUT WITH (nolock) JOIN
                      LLP_BDP_OUT LLP WITH (nolock)  ON llp.Num_Proc_LBO = Num_Proc_HBO                  


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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCliente'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCliente'
GO
