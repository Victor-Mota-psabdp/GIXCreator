SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Produto_Perigoso
CREATE procedure [dbo].[spATL_Produto_Perigoso_Sel]
(
	@cd_prod int,
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

--if @Tipo = 'A' or @Tipo = 'B'
--	Begin
--		select 
--			PP.cd_prod[Code],PC.cd_Proc_Cliente [Product Code],PC.cd_Cliente, 
--			P.apelido [Group],Produto_Descr [Description],
--			NCM_Cliente [N.C.M],uncode,classCode,HazMat_Name_Material,HazMat_Description,
--			HazMat_Contact,HazMat_Phone,FlashPoint,measureCode,packingCode,ShipperProperName,
--			MarinePollutant,MFAG,EMS,Density
--		from Produto_Perigoso PP with(nolock)			
--			join Produto_Cliente PC with(nolock) on PC.cd_prod = PP.cd_prod
--			join Pessoa P with(nolock) on P.Cd_Pes = PC.cd_Cliente
	
--	End


if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			PP.cd_prod				[Code],
			PC.cd_Proc_Cliente		[Product Code],
			PC.cd_Cliente			[Group Code], 
			P.apelido				[Group Name],
			uncode					[UN Code],
			classCode				[Class Code],
			HazMat_Name_Material	[Material Name],
			HazMat_Description		[Material Description],
			HazMat_Contact			[Contact],
			HazMat_Phone			[Phone Number],
			FlashPoint				[FlashPoint],
			measureCode				[Temperature],
			packingCode				[Packing Group],
			ShipperProperName		[Shipper Proper Name],
			MarinePollutant			[Marine Pollutant],
			MFAG					[MFAG],
			EMS						[EMS],
			Density					[Density]
		from Produto_Perigoso PP with(nolock)			
			join Produto_Cliente PC with(nolock) on PC.cd_prod = PP.cd_prod
			join Pessoa P with(nolock) on P.Cd_Pes = PC.cd_Cliente
		where
			PP.cd_prod = @cd_prod
	End	
	
--if @Tipo = 'N' or @Tipo = 'O'
--	Begin
--		select 
--			PP.cd_prod[Code],PC.cd_Proc_Cliente [Product Code],PC.cd_Cliente, 
--			P.apelido [Group],Produto_Descr [Description],
--			NCM_Cliente [N.C.M],uncode,classCode,HazMat_Name_Material,HazMat_Description,
--			HazMat_Contact,HazMat_Phone,FlashPoint,measureCode,packingCode,ShipperProperName,
--			MarinePollutant,MFAG,EMS,Density
--		from Produto_Perigoso PP with(nolock)			
--			join Produto_Cliente PC with(nolock) on PC.cd_prod = PP.cd_prod
--			join Pessoa P with(nolock) on P.Cd_Pes = PC.cd_Cliente
--		where
--			PC.cd_Cliente = @cd_cliente
--	End
	
	
--if @Tipo = 'Z' or @Tipo = 'O'
--	Begin
--		select 
--			PP.cd_prod[Code],PC.cd_Proc_Cliente [Product Code],PC.cd_Cliente, 
--			P.apelido [Group],Produto_Descr [Description],
--			NCM_Cliente [N.C.M],uncode,classCode,HazMat_Name_Material,HazMat_Description,
--			HazMat_Contact,HazMat_Phone,FlashPoint,measureCode,packingCode,ShipperProperName,
--			MarinePollutant,MFAG,EMS,Density
--		from Produto_Perigoso PP with(nolock)			
--			join Produto_Cliente PC with(nolock) on PC.cd_prod = PP.cd_prod
--			join Pessoa P with(nolock) on P.Cd_Pes = PC.cd_Cliente
--		where
--			PC.cd_Cliente = @cd_cliente and cd_Proc_Cliente = @cd_Proc_Cliente
--	End

GO
