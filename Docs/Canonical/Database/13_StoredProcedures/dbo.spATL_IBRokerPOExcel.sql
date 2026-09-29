SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spATL_IBRokerPOExcel](

@Processo varchar(16)
)
as
Declare @UnidadeMedida Table(
			Sigla varchar(4),
			CdSiscomex int
)
insert @UnidadeMedida
select 'KG',10 union select 'LTS',0 union select 'PE',0 union select 'TB',0 union select 'UN',0 union select 'L',61

select 

PC.cd_Proc_Cliente [CÓDIGO PRINCIPAL],
PC.cd_Proc_Cliente [CODIGO SECUNDARIO],
PCD.Produto_Descr [DESCRICAO RESUMIDA DO PRODUTO],
UM.CdSiscomex [UNIDADE MEDIDA],
PD.NCM [NCM],
PS.Qty [QUANTIDADE],
cast(isnull(PD.Peso_Liquido_TOT/PS.Qty,0) as decimal (12,04)) [PELO LIQUIDO UNITÁRIO],
cast(isnull(PD.Peso_Bruto_TOT/PS.Qty,0) as decimal (12,04)) [PESO BRUTO UNITÁRIO],
'000046'[CÓDIGO DO EXPORTADOR],
PCD.MEM_DESCRICAOPORTUGUES [DESCRICAO PORTUGUES],
PD.Vlr_Item [VALOR UNITARIO ITEM],
'999' [DESTAQUE DE ANUENCIA],
''[CÓDIGO DO FABRICANTE],
''[PAÍS DE ORIGEM],
''[NVE],
PCD.MEM_DESCRICAOPORTUGUES [DESCRICAO DO PRODUTO PARA NOTA FISCAL],
''[FATURA],
''[QUEBRA AUX],
'',
'',
'' [MOEDA],
'' [AREA],
'' [NECESSITA LI],
'' [Ordem de Compra]
 from Pedido_Ship PS
join Pedido_Det PD on PS.cd_pedido = PD.Cd_Pedido and PS.cd_produto = PS.cd_produto and PD.Item = PS.Item and PD.Lote = PS.Lote
join Pedido P on PS.cd_pedido = P.Cd_pedido
join Produto_Cliente PC on PD.cd_produto = PC.cd_prod and P.cd_grupo = PC.cd_Cliente
left join produto_cliente_DDGIP PCD on dbo.PreencheStringV2(PC.cd_Proc_Cliente,18,'0') = dbo.PreencheStringV2(PCD.cd_Proc_Cliente,18,'0')
left join @UnidadeMedida UM  on PD.UoM = UM.Sigla
where PS.num_proc = @Processo



GO
