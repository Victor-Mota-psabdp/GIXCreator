SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spATL_ConferenciaJOB_Sel]
(
	@Num_Proc varchar(16)
)
as

/*
========================================================================================================================= 
HISTORY CHANGE (From most recent to less recent)

. Date (YYYY/MM/DD):	2020/11/10 
. Ticket:				100-236919 - GSS - Billing authorization screen enhancement
. Business:				Eliene Alves Barbosa Oliveira (eliene.oliveira@bdpint.com) 
. Dept:					Transportation 
. Quality:				Rosangela Santos (rosangela.santos@bdpint.com)
. Developer:			Alessandra Suzuki Mariano (alessandra.mariano@bdpint.com)
. Developer review:		
=========================================================================================================================  
EXECUTION EXAMPLES  

exec spATL_ConferenciaJOB_Sel 'IAATL201911003BR'
========================================================================================================================= 
*/ 


select 
	V.num_proc, 
	Nome_BDP_Produto, 
	V.Master, 
	PS.Nome_Raz_Soc, 
	PS.Num_CPF_CNPJ,
	PG.Apelido Grupo,
	cast(V.Id_status as varchar(10))+ ' - ' + T.Status_Descricao [Status_Job],
	C.ID,C.Num_Proc,	
	isnull(C.Vr_Cambio,0) Vr_Cambio,
	isnull(C.Proft,0) Proft,
	C.Justificativa,
	C.Dt_Ins,
	C.Cd_Usuario,
	isnull(c.Status,'Pendente') [Status],
	
	CSR.Nome_Usuario CSR,
	C.dt_aproval_csr,
	C.Justificativa_csr,
	CHB.Nome_Usuario CHB,
	C.dt_aproval_chb,
	c.Justificativa_chb,
	Transp.Nome_Usuario Transp,	
	dt_aproval_transp,
	c.Justificativa_transp,
	
	--Alessandra 10/11/2020 - Ticket 100-236919
	Transp2.Nome_Usuario Transp2,	
	dt_aproval_transp2,
	c.Justificativa_transp2,

	isnull(INCO.Nome_Tp_Oper,'No Incoterm informed') Incoterm, 

	c.SaldoRepasse,
	c.SaldoResultado,
	isnull(c.Prestacao,0) Prestacao
	from vwClienteALLJOBS V			with(nolock)
	left join Confer_Job C		with(nolock) on C.Num_Proc = V.num_proc
	left join Tipo_Status_Processo T with(nolock) on T.ID_Status = V.ID_Status	
	left join Pessoa PS			with(nolock) on V.cd_cliente = PS.Cd_Pes
	Left Join Pessoa_LLP PLL	with(nolock) on PS.Cd_Pes = PLL.Cd_Pes
	Left Join Grupo G			with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	Left Join pessoa PG			with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
	left join Campo_Processo CP with(nolock) on V.num_proc = CP.Num_Proc and CP.Id_Campo = 143
	left join BDP_Produto PRO	with(nolock) on CP.Campo_Dados = PRO.ID_PD
	
	left join Usuario CSR with(nolock) on CSR.Cd_Usuario = C.cd_usuario_csr
	left join Usuario CHB with(nolock) on CHB.Cd_Usuario = C.cd_usuario_chb
	left join Usuario Transp with(nolock) on Transp.Cd_Usuario = C.cd_usuario_transp

	--Alessandra 10/11/2020 - Ticket 100-236919
	left join Usuario Transp2 with(nolock) on Transp2.Cd_Usuario = C.cd_usuario_transp2
	left join Tipo_Oper INCO     with(nolock) on v.Cd_Tp_Oper = INCO.Cd_Tp_Oper

Where
	V.num_proc = @Num_Proc


GO
