SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[USReportFin]-- '01-01-2009'
@data	char(10)

as

select Day(convert(datetime,dt_saida_mea,105)) Dias, 'EA' Modal, count(num_proc_hea) Qty,[dbo].[fBusca_Rent_DiaModal](LEFT(HOU.NUM_PROC_HEA,2),DT_SAIDA_MEA) Valor from house_exp_aer Hou
Join Master_exp_aer mas on mas.num_proc_mea=hou.num_proc_mea
Where
	convert(datetime,dt_saida_mea,105)>=@Data and convert(datetime,dt_saida_mea,105) <=getdate()
	AND [dbo].[fBusca_Rent_DiaModal](LEFT(HOU.NUM_PROC_HEA,2),DT_SAIDA_MEA) <>0
Group by 
Day(convert(datetime,dt_saida_mea,105)),LEFT(HOU.NUM_PROC_HEA,2),DT_SAIDA_MEA

UNION

select Day(convert(datetime,dt_saida_MEM,105)) Dias, 'EM' Modal, count(num_proc_HEM) Qty,[dbo].[fBusca_Rent_DiaModal](LEFT(HOU.NUM_PROC_HEM,2),DT_SAIDA_MEM) Valor from house_exp_MAR Hou
Join Master_exp_MAR mas on mas.num_proc_MEM=hou.num_proc_MEM
Where
	convert(datetime,dt_saida_MEM,105)>=@Data and convert(datetime,dt_saida_MEM,105) <=getdate()
	AND [dbo].[fBusca_Rent_DiaModal](LEFT(HOU.NUM_PROC_HEM,2),DT_SAIDA_MEM) <>0
Group by 
Day(convert(datetime,dt_saida_MEM,105)),LEFT(HOU.NUM_PROC_HEM,2),DT_SAIDA_MEM




UNION

select Day(convert(datetime,dt_ATRAC_MIM,105)) Dias, 'IM' Modal, count(num_proc_HIM) Qty,[dbo].[fBusca_Rent_DiaModal](LEFT(HOU.NUM_PROC_HIM,2),DT_ATRAC_MIM) Valor from house_IMP_MAR Hou
Join Master_IMP_MAR mas on mas.num_proc_MIM=hou.num_proc_MIM
Where
	convert(datetime,dt_ATRAC_MIM,105)>=@Data and convert(datetime,dt_ATRAC_MIM,105) <=getdate()
	AND [dbo].[fBusca_Rent_DiaModal](LEFT(HOU.NUM_PROC_HIM,2),DT_ATRAC_MIM) <>0
Group by 
Day(convert(datetime,dt_ATRAC_MIM,105)),LEFT(HOU.NUM_PROC_HIM,2),DT_ATRAC_MIM




UNION

select Day(convert(datetime,dt_CHEG_MIA,105)) Dias, 'IA' Modal, count(num_proc_HIA) Qty,[dbo].[fBusca_Rent_DiaModal](LEFT(HOU.NUM_PROC_HIA,2),DT_CHEG_MIA) Valor from house_IMP_AER Hou
Join Master_IMP_AER mas on mas.num_proc_MIA=hou.num_proc_MIA
Where
	convert(datetime,dt_CHEG_MIA,105)>=@Data and convert(datetime,dt_CHEG_MIA,105) <=getdate()
	AND [dbo].[fBusca_Rent_DiaModal](LEFT(HOU.NUM_PROC_HIA,2),DT_CHEG_MIA) <>0
Group by 
Day(convert(datetime,dt_CHEG_MIA,105)),LEFT(HOU.NUM_PROC_HIA,2),DT_CHEG_MIA


UNION

SELECT day(dt_conclusao) Dia, 'OTHER', COUNT(NUM_PROC), sum(dbo.spResultado(num_proc)) FROM TAREFAS_PROCESSOS
WHERE
	DT_CONCLUSAO >=@Data AND ID_TASK=4 and DT_CONCLUSAO <=getdate()
group by 
	day(dt_conclusao)


Order by 1


GO
