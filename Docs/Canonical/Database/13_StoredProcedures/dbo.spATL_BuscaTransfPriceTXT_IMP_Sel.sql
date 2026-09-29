SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_BuscaTransfPriceTXT_IMP_Sel]'2014'
CREATE procedure [dbo].[spATL_BuscaTransfPriceTXT_IMP_Sel]
@Ano varchar(4)
as
Declare @ID_NF varchar(50)
Declare @CD_Cliente varchar(50)
Declare @JOB varchar(16)


delete Percentual_Produto where Ano = @Ano and SUBSTRING(num_proc,3,3) in ('CSR','ROB') --and Num_Proc = 'IOCSR201411009BR'

insert Percentual_Produto
select distinct PS.Num_Proc,PS.cd_pedido,PS.cd_produto,PS.Item,
cast(DBO.fBuscaPorcentagem_CdPedido_Transf(PS.Num_Proc,PS.ITEM,PS.cd_pedido)*dbo.fBuscaPorcentagem_Pedido_Prod(PS.num_proc,PS.cd_pedido,PS.cd_produto)*dbo.[fBuscaPorcentagem_CdProduto_Transf](PS.num_proc,PS.cd_produto) as decimal(18,10)),
CP.Campo_Dados,@Ano
from Pedido_Ship PS with(nolock)
join PO_HIM PO with(nolock) on PS.Num_Proc = PO.Num_Proc_HIM and ID_DC = '5'
left  join Campo_Processo CP with(nolock) on PS.Num_Proc = CP.Num_Proc  and CP.Id_Campo = 31
where year(PO.Data_PO_HIM) = @Ano and  SUBSTRING(PS.num_proc,3,3) in ('CSR','ROB')   --and PS.Num_Proc = 'IOCSR201411009BR'

union ALL

select distinct PS.Num_Proc,PS.cd_pedido,PS.cd_produto,PS.Item,
cast(DBO.fBuscaPorcentagem_CdPedido_Transf(PS.Num_Proc,PS.ITEM,PS.cd_pedido)*dbo.fBuscaPorcentagem_Pedido_Prod(PS.num_proc,PS.cd_pedido,PS.cd_produto)*dbo.[fBuscaPorcentagem_CdProduto_Transf](PS.num_proc,PS.cd_produto) as decimal(18,10)),
CP.Campo_Dados,@Ano
from Pedido_Ship PS with(nolock)
join PO_HIA PO with(nolock) on PS.Num_Proc = PO.Num_Proc_HIA and ID_DC = '5'
left  join Campo_Processo CP with(nolock) on PS.Num_Proc = CP.Num_Proc  and CP.Id_Campo = 31
where year(PO.Data_PO_HIA) = @Ano and  SUBSTRING(PS.num_proc,3,3) in ('CSR','ROB')  --and PS.Num_Proc = 'IOCSR201411009BR' 

union ALL

select distinct PS.Num_Proc,PS.cd_pedido,PS.cd_produto,PS.Item,
cast(DBO.fBuscaPorcentagem_CdPedido_Transf(PS.Num_Proc,PS.ITEM,PS.cd_pedido)*dbo.fBuscaPorcentagem_Pedido_Prod(PS.num_proc,PS.cd_pedido,PS.cd_produto)*dbo.[fBuscaPorcentagem_CdProduto_Transf](PS.num_proc,PS.cd_produto) as decimal(18,10)),
CP.Campo_Dados,@Ano
from Pedido_Ship PS with(nolock)
join PO_HIO PO with(nolock) on PS.Num_Proc = PO.Num_Proc_HIO and ID_DC = '5'
left  join Campo_Processo CP with(nolock) on PS.Num_Proc = CP.Num_Proc  and CP.Id_Campo = 31
where year(PO.Data_PO_HIO) = @Ano and  SUBSTRING(PS.num_proc,3,3) in ('CSR','ROB') --and PS.Num_Proc = 'IOCSR201411009BR' 

delete Transf_Price_TXT_IMP where Ano = @Ano and SUBSTRING(num_proc,3,3) in ('CSR','ROB')  --and Num_Proc = 'IOCSR201411009BR'

Declare C_JOBs cursor for
	select distinct ID_NF,CD_Cliente,NC.Num_proc from nota_cliente NC  with(nolock)
	join vwPO_Imp PO  with(nolock) on NC.Num_Proc = PO.Num_Proc
	where year(PO.Data_DI) = @Ano and  SUBSTRING(NC.num_proc,3,3) in ('CSR','ROB')  --and NC.Num_Proc = 'IOCSR201411009BR' 
Open C_JOBs 
SET NOCOUNT ON
Fetch Next From C_JOBS Into @ID_NF,@CD_Cliente,@JOB
	While @@FETCH_STATUS = 0
		Begin
--print @ID_NF
--print @CD_Cliente
print @JOB
exec spATL_TransfPriceTXT_IMP_SelIns @ID_NF,@CD_Cliente,@JOB,@Ano
			Fetch Next From C_JOBS Into @ID_NF,@CD_Cliente,@JOB
		End
close C_JOBS
deallocate C_JOBS

select * from Transf_Price_TXT_IMP
where Ano = @Ano
/*
select 
Codigo_Empresa +
Codigo_Filial +
Codigo_Material +
Data_Operação +
Tipo_Documento +
Numero_Documento +
Item +
Natureza_Operacao +
Natureza_Estoque +
Quantidade +
Indicador_Lancamento +
Unidade_Medida +
Codigo_PF_PJ +
Categoria_PF_PJ +
Valor_Custo_Total +
Valor_Custo_Aduaneiro_Outros +
Valor_Frete_Internacional +
Valo_Seguro_Internacional +
Valor_Imposto_Importacao +
Utilizacao_SAP +
Divisao +
Numero_DI  +
Moeda  from Transf_Price_TXT_IMP

*/
GO
