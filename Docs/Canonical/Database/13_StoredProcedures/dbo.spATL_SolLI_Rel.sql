SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_SolLI_Rel '2018-01-01','2018-04-20',''
CREATE procedure [dbo].[spATL_SolLI_Rel](

@DataInicial datetime,
@DataFinal datetime,
@Operador varchar(100)
)
as
select Num_Solicitacao [#SLI] , Num_LI [#LI],Num_Proc [JOB], cast(convert(varchar(10),Dt_Solicitacao,103) as varchar(10))  [Dt. Sol], OP.Nome_Usuario [Operador]  from Solicitacao_LI SL with(nolock)
join Usuario US with(nolock) on US.Cd_Usuario = Sl.Cd_Usuario_Req
join Usuario OP with(nolock) on OP.Cd_Usuario = Sl.Cd_Usuario_Oper
where Dt_Solicitacao between @DataInicial and @DataFinal and (OP.Nome_Usuario = @Operador or  @Operador = '') and Num_Proc <>''
GO
