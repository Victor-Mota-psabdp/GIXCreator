SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select LLP.Num_Proc_Lem [JOB],convert(varchar(10),LLP.DL_Cargo_Lem,103) [Dead Line Draft],convert(varchar(10),LLP.DL_Draft_Lem,103) [Dead Line Cargo],convert(varchar(10),LLP.DL_VGM_Lem,103) [Dead Line VGM],Nr_Reserva [Booking] From LLP_Exp_Mar LLP join Job_Exp_Mar JOB on JOB.Num_Proc_HEM = LLP.Num_Proc_Lem where LLP.ID_Viagem = 'PARAMETRO'

--select * from Report_Detalhe
--select LLP.Num_Proc_Lem [JOB], convert(varchar(10),TP42.Dt_Conclusao,103) [Redestinação],TER.Nome_Terminal [Terminal] From LLP_Exp_Mar LLP Left Outer Join Terminal TER on LLP.Cd_Terminal = TER.Cd_Terminal Left Outer Join Tarefas_Processos TP42 on LLP.Num_Proc_Lem = TP42.Num_Proc and TP42.ID_Task = 42 where ID_Viagem = 'PARAMETRO'
--[spATL_NavioxViagem_Export_Rel]--'2010-01-01','2016-12-31'
CREATE PROCEDURE [dbo].[spATL_NavioxViagem_Export_Rel]--'2010-01-01','2016-12-31'
(
	@dt_inicial as datetime,
	@dt_final as datetime 
)
AS

select
	V.id_viagem			[ID],
	NV.Nome_Navio		[Navio/ jobs],	
	Convert(varchar(10),V.ETD,103)	[ETD],
	Convert(varchar(10),V.ETA,103)	[ETA],
	O.Descricao_OP		[LOCAL DE ATRACAÇÃO],
	P.Nome_pais			[NACIONALIDADE],
	V.Manifesto			[MANIFESTO],
	A.Nome_Armador		[AGÊNCIA]
from Viagem_LLP V with(nolock)
	left Join navio_LLP NV with(nolock) on V.id_navio = NV.Id_Navio
	left join Localidade L with(nolock) on L.Cd_Local  = V.Cd_Dst
	left join Tipo_Operador_Portuario O with(nolock) on O.ID_OP = V.id_op
	left join Pais P with(nolock) on P.cd_pais = NV.cd_pais
	left join Armador A with(nolock) on A.cd_armador = NV.cd_armador
Where
	v.ETD between @dt_inicial and @dt_final
	and Modal = 'E'
order by V.ETA

OPTION(HASH JOIN)
	
	
GO
