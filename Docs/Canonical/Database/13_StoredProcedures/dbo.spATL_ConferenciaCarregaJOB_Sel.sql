SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_ConferenciaCarregaJOB_Sel]--'IMCSR201609001BR'
(
	@Num_Proc varchar(16)
)
as

select 
	V.num_proc, 
	Nome_BDP_Produto, 
	V.Master, PS.Nome_Raz_Soc, 
	PC.Nome_Raz_Soc,PS.Num_CPF_CNPJ,
	PG.Apelido Grupo,
	cast(V.Id_status as varchar(10))+ ' - ' + T.Status_Descricao [Status_Job]
from vwClienteALLJOBS V with(nolock)
	left join Tipo_Status_Processo T with(nolock) on T.ID_Status = V.ID_Status
	left join Pessoa PC			with(nolock) on V.cd_fornecedor = PC.Cd_Pes
	left join Pessoa PS			with(nolock) on V.cd_cliente = PS.Cd_Pes
	Left Join Pessoa_LLP PLL	with(nolock) on PS.Cd_Pes = PLL.Cd_Pes
	Left Join Grupo G			with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	Left Join pessoa PG			with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
	left join Campo_Processo CP with(nolock) on V.num_proc = CP.Num_Proc and CP.Id_Campo = 143
	left join BDP_Produto PRO	with(nolock) on CP.Campo_Dados = PRO.ID_PD
Where
	V.num_proc = @Num_Proc


GO
