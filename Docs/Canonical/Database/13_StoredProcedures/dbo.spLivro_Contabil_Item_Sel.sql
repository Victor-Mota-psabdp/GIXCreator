SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spLivro_Contabil_Item_Sel]
	@ID int
As
	select 
		'Saved' [Status], Item [Nº], Job [BDP Ref.], Valor [Value], 
		CC.cd_cta_ctb_red [Account CREDIT], CC.nome_cta_ctb [Account Credit Name], CC.cd_cta_ctb [Credit Code],
		CD.cd_cta_ctb_red [Account DEDIT], CD.nome_cta_ctb [Account Dedit Name], CD.cd_cta_ctb [Debit Code],
		Historico [Historic], Historico2 [Historic (2nd)], Cd_Usuario [User]
	from
		livro_contabil_item LCI
		left join cta_ctb CC on CC.cd_cta_ctb = LCI.ContaCredito
		left join cta_ctb CD on CD.cd_cta_ctb = LCI.ContaDebito
	where
		id = @ID



--select * from cta_ctb where ck_ativo='S' order by 1

GO
