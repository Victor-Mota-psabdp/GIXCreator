SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spNF_Import_Infineum_teste_Rel] --[spNF_Import_Infineum_teste_Rel]'IMIFB202603015BR'

	@Num_Proc varchar(16)
	
as

--Set @Num_Proc = 'IMIFB202511023BR' --IMIFB202510092BR   

SELECT distinct
	'',
	'0000000000' + PC.cd_Proc_Cliente as [Material],
	PL.Cd_Planta AS [Planta],
	LTRIM(RTRIM(NFD.Peso_Liquido))  [Qtd],  
	'kg' [UNIDADE],
	REPLACE(
    FORMAT(
        CAST(NFD.VL_BASE_COFINS / NULLIF(NFD.Quantidade, 0) AS DECIMAL(18,3)),
        '#,##0.######',   -- até 6 decimais, sem zeros finais
        'en'           -- milhares = '.', decimal = ','
		 ),
		'.', ''              -- remove a vírgula do decimal: "20.060,417" -> "20.060417"
		) AS [Preco Unitario]
	,NC.CFOP + '/01' [CFOP], -- pegar da tela da nota fiscal
	'90' [CST ICMS],
	'00' [CST IPI],
	'56' [CST PIS],
	'56' [CST COF],
	'0,00' [Desconto],
	'0,00' [Frete],
	'0,00' [Seguro],
	Cast(NFD.vl_imposto_pis + NFD.VL_imposto_cofins + ([dbo].[fBusca_CustoCliente] (@num_proc, '%AFRMM%')) + ([dbo].[fBusca_CustoCliente] (@num_proc, '%Siscomex%')) as decimal(18,2)) as [Despesas],
	'ICM2' [ICMS],
	cast(NFD.ALIQ_ICMS as decimal (18,2)) [Alíquotas],
	REPLACE(
	cast(NFD.VL_BASE_ICMS as decimal (18,2)),
		'.', ',' )[Base],
	'0,00' [Outras],
	'0,00' [Excl. - Isento],
	REPLACE(
	cast(NFD.VL_ICMS  as decimal (18,2)),
	'.', ',' ) [Valor ICMS],
	'IPI1' [IPI],
	cast(NFD.ALIQ_IPI  as decimal (18,2)) [Alíquotas1],
	REPLACE(
	cast(NFD.VL_BASE_IPI  as decimal (18,2)),
	'.', ',' ) [Base1],
	'0,00' [Outras1],
	'0,00' [Excl. - Isento1],
	REPLACE(
	cast(NFD.VL_IPI as decimal (18,2)),
	'.', ',' ) [Valor IPI1],
	'IPIS' [PIS],
	cast(NFD.VL_ALIQ_PIS as decimal (18,2)) [Alíquotas2],
	REPLACE(
	cast(NFD.VL_BASE_PIS as decimal (18,2)),
	'.', ',' ) [Base2],
	REPLACE(
	cast(NFD.VL_IMPOSTO_PIS as decimal (18,2)),
	'.', ',' ) [Valor PIS],
	'ICOF' [COFINS],
	cast(NFD.VL_ALIQ_COFINS as decimal (18,2)) [Alíquotas3],
	REPLACE(
	cast(NFD.VL_BASE_COFINS as decimal (18,2)),
	'.', ',' ) [Base3],
	REPLACE(
	cast(NFD.VL_IMPOSTO_COFINS as decimal (18,2)),
	'.', ',' ) [Valor COFINS],
	'II01' [Imposto Import],
	cast(NFD.ALIQ_II  as decimal (18,2)) [Taxa],
	REPLACE(
	cast(NFD.VL_BASE_II  as decimal (18,2)),
	'.', ',' ) [Base4],
	REPLACE(
	cast(NFD.VL_II as decimal (18,2)),
	'.', ',' ) [Valor],
	'II02' [IOF],
	'0,00' [Valor1],
	'II03' [Desp. Adu],
	NFD.Vlr_Siscomex [Valor2],
	'PISD' [ICMS Gross-up],
	REPLACE(
	cast(NFD.VL_ICMS as decimal (18,2)),
	'.', ',' ) [Valor3],
	'0' [Item],
	REPLACE(REPLACE(REPLACE(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'5'), '.', ''), '/', ''), '-', '') [Numero da DI],
	'1' [Numero],
	'1' [Item],
	'Infineum' [Fabricante],
	'R$ ' + CONVERT(VARCHAR, CAST(NFD.Vlr_Total_NF AS DECIMAL(18,2))) [Check VR Total da NF]

FROM vwhouse_imp HOU WITH(NOLOCK)
JOIN localidade LO WITH(NOLOCK) ON HOU.Cd_Org = LO.Cd_Local
JOIN localidade LD WITH(NOLOCK) ON HOU.Cd_Dst = LD.Cd_Local
JOIN Pedido_Ship PS WITH(NOLOCK) ON HOU.num_proc = PS.Num_Proc
JOIN Produto_Cliente PC WITH(NOLOCK) ON PS.cd_produto = PC.cd_prod 
JOIN Nota_Cliente NC WITH(NOLOCK) ON HOU.num_proc = NC.Num_Proc
JOIN Nota_Fiscal_Cliente_Det NFD WITH(NOLOCK) ON PS.cd_produto = NFD.Cd_Produto 
	AND PS.cd_pedido = NFD.Cd_Pedido 
	AND NFD.ID_NF = NC.ID_NF 
	AND NFD.Cd_Cliente = NC.CD_Cliente
LEFT JOIN Campo_Processo CP WITH(NOLOCK) ON HOU.Num_Proc = CP.Num_Proc AND CP.Id_Campo = '25'
LEFT JOIN Localidade LCP WITH(NOLOCK) ON CP.Campo_Dados = LCP.Cd_Local
LEFT JOIN Tarefas_Processos TP4 WITH(NOLOCK) ON HOU.Num_Proc = TP4.Num_Proc AND TP4.ID_Task = '4'
LEFT JOIN Pessoa P WITH(NOLOCK) ON HOU.Cd_Consig = P.Cd_Pes
LEFT JOIN Pessoa_LLP PL WITH(NOLOCK) ON p.Cd_Pes = PL.Cd_Pes
LEFT JOIN Campo_Processo CP31 WITH(NOLOCK) ON HOU.Num_Proc = CP31.Num_Proc AND CP31.Id_Campo = '31'
LEFT JOIN DE_PARA DP WITH(NOLOCK) ON PC.cd_Proc_Cliente = DP.Cd_Org and DP.Cd_Tipo = 37
WHERE HOU.Num_Proc = @Num_Proc
	--AND TP4.Dt_Conclusao IS NOT NULL



GO
