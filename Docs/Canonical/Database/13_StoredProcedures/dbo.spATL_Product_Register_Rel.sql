SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Produto_Cliente
--sp_help Produto_CHB
--[spATL_Product_Register_Rel] 'Grupo Sherwin'
CREATE Procedure [dbo].[spATL_Product_Register_Rel]
(
	@Grupo varchar(20)
)
as

Declare @Cd_Pes varchar(10)
set @Cd_Pes = (select Cd_Pes from Pessoa where Apelido = @Grupo)

select 
	PC.cd_prod				[Code], 
	PC.cd_Proc_Cliente		[Product Code],
	PC.cd_Cliente			[Group Code], 
	P.Apelido				[Group Name],
	PC.Produto_Descr		[Product Description],
	NCM_Cliente				[N.C.M], 
	N.Descricao_NCM			[N.C.M Description],
	
	--Produto chb
	PH.Etiqueta_Produto		[Product Tag],
	PH.Tipo_LI				[IL Type],
	PH.Aprovado				[Approved],
	PH.Orgao_Anuente		[Orgao Anuente],		
	convert(varchar(10),PH.Dt_Pesquisa,103)[Date Search],
	PH.Pais_Origem			[Origin Country Code], 
	PA.Nome_Pais			[Origin Country Name],			
	PH.Import_License		[Import License],			
	PH.Concentracao			[Concentration],
	PH.Descricao_Longa		[Full Product Description],
	
	--Produto Perigoso
	PP.uncode					[UN Code],
	PP.classCode				[Class Code],
	PP.HazMat_Name_Material		[Material Name],
	PP.HazMat_Description		[Material Description],
	PP.HazMat_Contact			[Contact],
	PP.HazMat_Phone				[Phone Number],
	PP.FlashPoint				[FlashPoint],
	PP.measureCode				[Temperature],
	PP.packingCode				[Packing Group],
	PP.ShipperProperName		[Shipper Proper Name],
	PP.MarinePollutant			[Marine Pollutant],
	PP.MFAG						[MFAG],
	PP.EMS						[EMS],
	PP.Density					[Density],
	
	--DE_PARA_PRODUTO
	DPP.GMID_Descr_Curta			[GMID Short Description],
	DPP.Trade_Product_Code			[Product Trade Code],
	DPP.Trade_Product_Descr			[Product Trade Description],
	DPP.Plan_Product_Code			[Product Plan Code],
	DPP.Plan_Product_Descr			[Product Plan Description],
	DPP.Product_Center_Code     	[Product Center Code],
	DPP.Product_Center_Descr		[Product Center Description],
	DPP.Performance_Center_Code 	[Performance Center Code],
	DPP.Performance_Center_Descr 	[Performance Center Description],
	DPP.Value_Center_Code 			[Value Center Code],
	DPP.Value_Center_Descr 			[Value Center Description],
	DPP.Business_Code 				[Business Code],
	DPP.Business_Descr				[Business Description],
	DPP.Business_Group_Code			[Business Group Code],
	DPP.Business_Group_Descr		[Business Group Description],
	DPP.P_Descricao					[P Description],
	DPP.S_Descricao					[S Description],
	DPP.ITO_Especialista			[ITO Especialist],
	
	--Campo_Produto_Cliente
	V1.Descricao					[LI Reg. Especial],
	V2.Descricao					[Necessita Drawback],
	CPP3.Campo_Dados				[Responsável Revisão],
	CPP4.Campo_Dados				[Envio D. de Origem ao Cliente],
	CPP5.Campo_Dados				[Receb. D. de Origem Cliente],
	CPP6.Campo_Dados				[Cadastro D. Origem na FIESP],
	CPP7.Campo_Dados				[Declaração de Origem],
	CPP8.Campo_Dados				[Vencimento Declaracao Produto],	
	V9.Descricao					[Atende o Requisito?],
	V10.NOME_TP_ITO_Specialist 		[Controle DO?],	
	V11.Descricao					[ITO Responsável],
	CPP12.Campo_Dados				[Comentários],
	V13.Descricao					[EX],
	V14.Descricao					[DUMPING],
	CPP15.Campo_Dados				[NVE],
	CPP16.Campo_Dados				[CFOP]
from Produto_Cliente			PC	with(nolock)
	JOIN Pessoa					P	with(nolock) on PC.cd_Cliente = P.Cd_Pes
	LEFT JOIN NCM				N	with(nolock) on PC.NCM_Cliente = N.NCM
	LEFT JOIN Produto_CHB		PH	with(nolock) on PC.cd_prod = PH.cd_prod
	LEFT JOIN Pais				PA	with(nolock) on PH.Pais_Origem = PA.Cd_Pais
	LEFT JOIN Produto_Perigoso	PP	with(nolock) on PC.cd_prod = PP.cd_prod
	LEFT JOIN DE_PARA_PRODUTO	DPP with(nolock) on PC.cd_Proc_Cliente = DPP.GMID AND PC.Cd_Cliente = DPP.cd_Cliente
	
	LEFT JOIN Campo_Produto_Cliente CPP1 with(nolock) on PC.cd_prod = CPP1.cd_prod and CPP1.Id_Campo = 1 
	LEFT JOIN Verdade				V1	with(nolock) on CPP1.Campo_Dados = cast(V1.Id as varchar(1))
	
	LEFT JOIN Campo_Produto_Cliente CPP2 with(nolock) on PC.cd_prod = CPP2.cd_prod and CPP2.Id_Campo = 2 
	LEFT JOIN Verdade				V2	with(nolock) on CPP2.Campo_Dados = cast(V2.Id as varchar(1))
	
	LEFT JOIN Campo_Produto_Cliente CPP3 with(nolock) on PC.cd_prod = CPP3.cd_prod and CPP3.Id_Campo = 3 
	LEFT JOIN Campo_Produto_Cliente CPP4 with(nolock) on PC.cd_prod = CPP4.cd_prod and CPP4.Id_Campo = 4 
	LEFT JOIN Campo_Produto_Cliente CPP5 with(nolock) on PC.cd_prod = CPP5.cd_prod and CPP5.Id_Campo = 5
	LEFT JOIN Campo_Produto_Cliente CPP6 with(nolock) on PC.cd_prod = CPP6.cd_prod and CPP6.Id_Campo = 6 
	LEFT JOIN Campo_Produto_Cliente CPP7 with(nolock) on PC.cd_prod = CPP7.cd_prod and CPP7.Id_Campo = 7 
	LEFT JOIN Campo_Produto_Cliente CPP8 with(nolock) on PC.cd_prod = CPP8.cd_prod and CPP8.Id_Campo = 8 
	
	LEFT JOIN Campo_Produto_Cliente CPP9 with(nolock) on PC.cd_prod = CPP9.cd_prod and CPP9.Id_Campo = 9 
	LEFT JOIN Verdade				V9	with(nolock) on CPP9.Campo_Dados = cast(V9.Id as varchar(1))
	
	LEFT JOIN Campo_Produto_Cliente CPP10 with(nolock) on PC.cd_prod = CPP10.cd_prod and CPP10.Id_Campo = 10 
	LEFT JOIN Tipo_ITO_Specialist	V10	with(nolock) on CPP10.Campo_Dados = cast(V10.ID_TP_ITO_Specialist as varchar(5))
	
	LEFT JOIN Campo_Produto_Cliente CPP11 with(nolock) on PC.cd_prod = CPP11.cd_prod and CPP11.Id_Campo = 11 
	LEFT JOIN Verdade				V11	with(nolock) on CPP11.Campo_Dados = cast(V11.Id as varchar(1))
	
	LEFT JOIN Campo_Produto_Cliente CPP12 with(nolock) on PC.cd_prod = CPP12.cd_prod and CPP12.Id_Campo = 12 
	
	LEFT JOIN Campo_Produto_Cliente CPP13 with(nolock) on PC.cd_prod = CPP13.cd_prod and CPP13.Id_Campo = 13 
	LEFT JOIN Verdade				V13	with(nolock) on CPP13.Campo_Dados = cast(V13.Id as varchar(1))
	
	
	LEFT JOIN Campo_Produto_Cliente CPP14 with(nolock) on PC.cd_prod = CPP14.cd_prod and CPP14.Id_Campo = 14 
	LEFT JOIN Verdade				V14	with(nolock) on CPP14.Campo_Dados = cast(V14.Id as varchar(1))
	
	LEFT JOIN Campo_Produto_Cliente CPP15 with(nolock) on PC.cd_prod = CPP15.cd_prod and CPP15.Id_Campo = 15 
	LEFT JOIN Campo_Produto_Cliente CPP16 with(nolock) on PC.cd_prod = CPP16.cd_prod and CPP16.Id_Campo = 16	
	
WHERE 
	PC.cd_Cliente = @Cd_Pes
	


GO
