SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spCarregaMiros_Sel] 
(
	@Num_Proc varchar(16),
	@Evento char(1)
)
AS
	select --*  
		(Case
			when ID_Evento = 'C' Then 'C - Frete'
			when ID_Evento = 'F' Then 'F - Despesas Operacionais'
			when ID_Evento = 'I' Then 'I - Fatura'
			when ID_Evento = 'S' Then 'S - Seguro'
			when ID_Evento = 'T' Then 'T - Impostos'
			when ID_Evento = 'R' Then 'R - Impostos Recuperaveis'
			when ID_Evento is NULL Then 'NOT Found'
		End) [Type                                   ],
		TT.nome_tp_tx + space(30) + TT.cd_tp_tx  [Description                        ],
		Conta_Credito [Account Code],
		Vlr_Item_Custo [Value               ]
	from 
		custo_cliente CC 
		left join FMC_Plano_Contas_V2 FPC on FPC.cd_tp_tx=CC.cd_tp_tx
		left join tipo_taxa TT on TT.cd_tp_tx = CC.cd_tp_tx
	where 
		num_proc = @Num_Proc and (ID_Evento = @Evento or ID_Evento is NULL or @Evento = 'A') and Num_NF_Custo is null
	order by 
		Id_Evento

GO
