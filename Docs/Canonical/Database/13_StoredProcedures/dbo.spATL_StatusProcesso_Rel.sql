SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure spATL_StatusProcesso_Rel
(
	@DtInicial datetime,
	@DtFinal datetime
)
as
select  Num_Proc [BDP Ref.], G.Apelido, P.Nome_Raz_Soc [Cliente], CAST(T.ID_Status as varchar(10)) +'-'+ T.Status_Descricao [Status]   from vwHouse_Imp H with(nolock)
join Pessoa P with(nolock) on H.Cd_Consig = P.Cd_Pes 
join Tipo_Status_Processo T with(nolock) on H.ID_Status = T.ID_Status
left join Pessoa_LLP PL with(nolock) on PL.Cd_Pes = P.Cd_Pes
left join Pessoa G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes
where CONVERT(datetime, Dt_Emis,103) between @DtInicial and @DtFinal

union all
select  Num_Proc [BDP Ref.], G.Apelido, P.Nome_Raz_Soc [Cliente],  CAST(T.ID_Status as varchar(10)) +'-'+ T.Status_Descricao [Status]   from vwHouse_Exp H with(nolock)
join Pessoa P with(nolock) on H.Cd_Export = P.Cd_Pes 
join Tipo_Status_Processo T with(nolock) on H.ID_Status = T.ID_Status
left join Pessoa_LLP PL with(nolock) on PL.Cd_Pes = P.Cd_Pes
left join Pessoa G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes
where CONVERT(datetime, Dt_Emis,103) between @DtInicial and @DtFinal


GO
