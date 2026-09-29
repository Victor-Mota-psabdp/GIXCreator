SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spFaturaArgAjusteDET_Sel '67650', '59148','A'
CREATE procedure [dbo].[spFaturaArgAjusteDet_Sel](
	@ID_Fat int,
	@Num_NF varchar(12),
	@Ref_Acesso_NF char(1)
)
as
select @ID_Fat ID_Fat, CC.Num_Proc_HIA, TT.Nome_Tp_Tx,CC.DC_HIA,TM.Nome_Tp_Moeda,CC.Vlr_Org_HIA,CC.Vlr_Pgto_NF_HIA ,CC.Par_NF_HIA,0  from vwcta_Cte CC with(nolock)
left join Tipo_Taxa TT with(nolock) on CC.Cd_Tp_Tx = TT.Cd_Tp_Tx
left join Tipo_Moeda TM with(nolock) on CC.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
where Num_NF_hia = @Num_NF and Ref_Acesso_NF_HIA = @Ref_Acesso_NF

/*
select top 1 * from vwcta_cte

sp_help fatura_arg
sp_help fatura_arg_det
select * from fatura_arg
select top 1 * from fatura_arg_det
*/

GO
