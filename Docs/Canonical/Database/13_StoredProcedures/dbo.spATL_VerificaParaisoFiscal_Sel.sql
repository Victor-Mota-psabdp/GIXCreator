SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_VerificaParaisoFiscal_Sel 'IAOSR201712006br'
create procedure [dbo].[spATL_VerificaParaisoFiscal_Sel](
@Num_Proc varchar(16)
)
as
--select P.Cd_Pais,isnull(TT.Nome_Tp_Tx,'Paraiso Fiscal 1 - D' ) Nome_Tp_Tx  from vwHouse_Imp HOU with(nolock)
--join Localidade L with(nolock) on L.Cd_Local = HOU.Cd_Org
--join Pais		P with(nolock)	on P.Cd_Pais = L.Cd_Pais
--left join vwcta_Cte CC with(nolock) on CC.Num_Proc_HIA = HOU.Num_Proc and CC.Cd_Tp_Tx = '243' and CC.DC_HIA = 'D'
--left join Tipo_Taxa TT  with(nolock) on CC.Cd_Tp_Tx = TT.Cd_Tp_Tx 
--where Num_Proc = @Num_Proc and P.Paraiso_Fiscal = 1  and CC.Cd_Tp_Tx is null
--union all
select P.Cd_Pais,isnull(TT.Nome_Tp_Tx,'Paraiso Fiscal 1 - C') Nome_Tp_Tx  from vwHouse_Imp HOU with(nolock)
join Localidade L with(nolock) on L.Cd_Local = HOU.Cd_Org
join Pais		P with(nolock)	on P.Cd_Pais = L.Cd_Pais
left join vwcta_Cte CC with(nolock) on CC.Num_Proc_HIA = HOU.Num_Proc and CC.Cd_Tp_Tx = '243' and CC.DC_HIA = 'C'
left join Tipo_Taxa TT  with(nolock) on CC.Cd_Tp_Tx = TT.Cd_Tp_Tx 
where Num_Proc = @Num_Proc and P.Paraiso_Fiscal = 1 and CC.Cd_Tp_Tx is  null
union all
--select P.Cd_Pais,isnull(TT.Nome_Tp_Tx,'Paraiso Fiscal 1 - D' ) Nome_Tp_Tx  from vwHouse_Exp HOU with(nolock)
--join Localidade L with(nolock) on L.Cd_Local = HOU.Cd_Dst
--join Pais		P with(nolock)	on P.Cd_Pais = L.Cd_Pais
--left join vwcta_Cte CC with(nolock) on CC.Num_Proc_HIA = HOU.Num_Proc and CC.Cd_Tp_Tx = '243' and CC.DC_HIA = 'D'
--left join Tipo_Taxa TT  with(nolock) on CC.Cd_Tp_Tx = TT.Cd_Tp_Tx 
--where Num_Proc = @Num_Proc and P.Paraiso_Fiscal = 1  and CC.Cd_Tp_Tx is null
--union all
select P.Cd_Pais,isnull(TT.Nome_Tp_Tx,'Paraiso Fiscal 1 - C') Nome_Tp_Tx  from vwHouse_Exp HOU with(nolock)
join Localidade L with(nolock) on L.Cd_Local = HOU.Cd_Dst
join Pais		P with(nolock)	on P.Cd_Pais = L.Cd_Pais
left join vwcta_Cte CC with(nolock) on CC.Num_Proc_HIA = HOU.Num_Proc and CC.Cd_Tp_Tx = '243' and CC.DC_HIA = 'C'
left join Tipo_Taxa TT  with(nolock) on CC.Cd_Tp_Tx = TT.Cd_Tp_Tx 
where Num_Proc = @Num_Proc and P.Paraiso_Fiscal = 1 and CC.Cd_Tp_Tx is null

GO
