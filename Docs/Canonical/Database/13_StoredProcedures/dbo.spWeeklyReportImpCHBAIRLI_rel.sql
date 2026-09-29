SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE Procedure [dbo].[spWeeklyReportImpCHBAIRLI_rel] --'07-01-2008','07-31-2008'
		@DataInicial	Varchar(10),
		@DataFinal		VarChar(10)

as

select 
	'Air' Modal, Nome_Local,Isnull(Canal_LIA,'Green') Canal,
	Case 
		When  dbo.quantidade_dias(Ata_lia,Dt_conclusao) between 1 and 5 then '1-5'
		when  dbo.quantidade_dias(Ata_lia,Dt_conclusao) between 6 and 10 then '6´-10'
		When  dbo.quantidade_dias(Ata_lia,Dt_conclusao)  between 11 and 15 then '7-10'
		When  dbo.quantidade_dias(Ata_lia,Dt_conclusao) > 15 then '>15'
	end
Faixa
,
count(Num_Proc_Lia) Processo,
'LCL' Tipo_Carga,
month(dt_conclusao) Mes,
Isnull(Id_DC,0) LI
from 
	llp_imp_aer
	Join House_imp_aer hou on hou.num_proc_hia=num_proc_lia
	Join Localidade DST on DST.cd_local=cd_dst_hia
	Join Tarefas_Processos TF on num_proc_lia=TF.num_proc and TF.ID_Task=4 and TF.Dt_conclusao is not null
	Left Join PO_HIA LI on num_proc_lia=li.num_proc_hia and Id_dc=23
Where
	TF.Dt_Conclusao between @DataInicial and @DataFinal AND ATA_LIA is not null

Group by 	Nome_Local,Isnull(Canal_LIA,'Verde'),
	cast((Dt_Conclusao - ATA_Lia) as int),	 
Isnull(Canal_LIA,'Green') ,dt_conclusao,
	ATA_LIA, Isnull(Id_DC,0) 


GO
