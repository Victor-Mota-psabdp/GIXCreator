SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_WebExcimBusca_Sel]

as
insert Into exchange_Excim

select excprocesso Job,min(EX.ExcId),NULL from exchange EX with(nolock)
left join exchange_Excim EXC with(nolock) on EX.ExcID= EXC.ExcID
join vwCliente VW with(nolock) on EX.excprocesso = VW.Num_Proc
Join Pessoa_LLP	PLL	With(nolock) on vw.cd_cliente = PLL.Cd_Pes and PLL.Cd_Pes_Grupo in ('P20562')
where Exc.ExcId is NULL and ExcDataAlt >= getdate()-15 and Data >=getdate() -30 
group by excprocesso
/*
select excprocesso Job,min(EX.ExcId),NULL from exchange EX with(nolock)
left join exchange_Excim EXC with(nolock) on EX.excprocesso= EXC.Num_proc 
join vwCliente VW with(nolock) on EX.excprocesso = VW.Num_Proc
Join Pessoa_LLP	PLL	With(nolock) on vw.cd_cliente = PLL.Cd_Pes and PLL.Cd_Pes_Grupo in ('P20562')
where EXC.Num_proc is NULL and Exc.ExcId is NULL  and ExcDataAlt >= getdate()-15 and Data >=getdate() -30 group by  excprocesso 

*/
select * from exchange_Excim

--where excid = '16322722'
--delete exchange_Excim
--where num_proc = 'IMEXC201311010BR'
where Dt_Envio is NULL


GO
