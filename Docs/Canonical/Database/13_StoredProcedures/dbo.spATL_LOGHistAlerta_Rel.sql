SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_LOGHistAlerta_Rel](
@Grupo varchar(50),
@DataInicial datetime,
@DataFinal datetime,
@Mensagem varchar(200)
)
as
select num_proc Processo, HSGData [Data Historico], PS.Apelido [Grupo],HSDDescricao [Historico] from Hist_Geral H with (nolock)
join vwCliente vw with (nolock) on H.HSGProcesso = vw.num_proc
join Pessoa_LLP P with (nolock) on vw.cd_cliente = P.Cd_Pes
join Pessoa PS with (nolock) on PS.Cd_Pes = P.Cd_Pes_Grupo
where PS.Apelido = @Grupo and  HSGData between @DataInicial and @DataFinal and  HSDDescricao like @Mensagem
group by num_proc,HSGData, PS.Apelido,HSDDescricao
order by HSGData

--'Alert: FATURAMENTO BDP%'
GO
