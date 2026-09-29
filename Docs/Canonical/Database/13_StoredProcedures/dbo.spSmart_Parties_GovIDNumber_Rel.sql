SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSmart_Parties_GovIDNumber_Rel]--'EAGRU201610006'

		@Processo 	VarChar(14)

AS	

--178	10017	S	Armador do MBL
--SELECT * FROM Tipo_Campo_Cliente WHERE Id_Campo = 178
select 	
	(case when UPPER(ENDC.CD_pais) = 'CN' THEN
		(case when isnull(dbo.fBusca_CampoCliente(MEA.num_proc_mea,178),'BDP') = 'BDP' then 
			'EIN23-1878776'
		ELSE
			'EIN20-8141384'	
		end) 
	ELSE
		'' end)			EINCode,
	(case when UPPER(ENDC.CD_pais) = 'CN' THEN
		CP18.Campo_Dados ELSE
		null END)		USCI_CODE
	
from 
	Master_Exp_Aer					MEA with(nolock)
	Left Outer Join LLP_Master		LLP	with(nolock) on MEA.num_proc_mea = LLP.Num_Proc_master
	JOIN House_Exp_Aer				HOU	with(nolock) on MEA.num_proc_mea = HOU.Num_Proc_MEA
	Left Join Pessoa				CS	with(nolock) on CS.cd_pes=MEA.cd_consig_mea
	Left Join Endereco				ENDC with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	left Outer join Campo_Pessoa	CP18 with(nolock) ON CP18.Cd_Pes = CS.Cd_Pes and CP18.Id_Campo = '18'
Where
	MEA.Num_Proc_mea=@Processo
	AND HOU.Num_Proc_MEA <> 'JOB'


union all

select 	
	(case when UPPER(ENDC.CD_pais) = 'CN' THEN
		(case when isnull(dbo.fBusca_CampoCliente(MEA.Num_Proc_MEM,178),'BDP') = 'BDP' then 
			'EIN23-1878776'
		ELSE
			'EIN20-8141384'	
		end) 
	ELSE
		'' end)			EINCode,
	(case when UPPER(ENDC.CD_pais) = 'CN' THEN
		CP18.Campo_Dados ELSE
		null END)		USCI_CODE
	
from 
	Master_Exp_Mar					MEA with(nolock)
	Left Outer Join LLP_Master		LLP	with(nolock) on MEA.Num_Proc_MEM = LLP.Num_Proc_master
	JOIN House_Exp_Mar				HOU	with(nolock) on MEA.Num_Proc_MEM = HOU.Num_Proc_MEM
	Left Join Pessoa				CS	with(nolock) on CS.cd_pes=MEA.Cd_Consig_MEM
	Left Join Endereco				ENDC with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	left Outer join Campo_Pessoa	CP18 with(nolock) ON CP18.Cd_Pes = CS.Cd_Pes and CP18.Id_Campo = '18'
Where
	MEA.Num_Proc_MEM=@Processo
	AND HOU.Num_Proc_MEM <> 'JOB'






	
	
	
	
	




GO
