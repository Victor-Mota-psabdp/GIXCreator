SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Site
CREATE procedure [dbo].[spATLDN_Site_Sel]--null,'Teste','Z'
(
	@Cd_Site		char(1),
	@Nome_Site		varchar(30),
	@Tipo			char(1)
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

if @Tipo = 'A' 
	Begin
		select 
			Cd_Site			[Code],
			Nome_Site		[Site Name],
			Aliq_Pis		[Aliq_Pis],
			Aliq_Cofins		[Aliq_Cofins],
			Aliq_IRRF		[Aliq_IRRF],
			Aliq_CSLL		[Aliq_CSLL],			
			Aliq_ISS		[Aliq_ISS],
			Site_AX			[Site_AX],
			Status			[Enabled]
		from 
			Site T with(nolock)			
	End
	
if  @Tipo = 'B'
	Begin
		select 
			Cd_Site			[Code],
			Nome_Site		[Site Name],
			Aliq_Pis		[Aliq_Pis],
			Aliq_Cofins		[Aliq_Cofins],
			Aliq_IRRF		[Aliq_IRRF],
			Aliq_CSLL		[Aliq_CSLL],			
			Aliq_ISS		[Aliq_ISS],
			Site_AX			[Site_AX],
			Status			[Enabled]
		from 
			Site T with(nolock)	
		where
			Status = 1
	End

if @Tipo = 'C'
	Begin
		select 
			Cd_Site			[Code],
			Nome_Site		[Site Name],
			Aliq_Pis		[Aliq_Pis],
			Aliq_Cofins		[Aliq_Cofins],
			Aliq_IRRF		[Aliq_IRRF],
			Aliq_CSLL		[Aliq_CSLL],			
			Aliq_ISS		[Aliq_ISS],
			Site_AX			[Site_AX],
			Status			[Enabled]
		from 
			Site T with(nolock)	
		where
			Cd_Site	 = @Cd_Site
			and	Status = 1
	End
	
if @Tipo = 'D'
	Begin
		select 
			Cd_Site			[Code],
			Nome_Site		[Site Name],
			Aliq_Pis		[Aliq_Pis],
			Aliq_Cofins		[Aliq_Cofins],
			Aliq_IRRF		[Aliq_IRRF],
			Aliq_CSLL		[Aliq_CSLL],			
			Aliq_ISS		[Aliq_ISS],
			Site_AX			[Site_AX],
			Status			[Enabled]
		from 
			Site T with(nolock)	
		where
			Cd_Site	 = @Cd_Site
			and	Status = 1
	End
	
if @Tipo = 'N'
	Begin
		select 
			Cd_Site			[Code],
			Nome_Site		[Site Name],
			Aliq_Pis		[Aliq_Pis],
			Aliq_Cofins		[Aliq_Cofins],
			Aliq_IRRF		[Aliq_IRRF],
			Aliq_CSLL		[Aliq_CSLL],			
			Aliq_ISS		[Aliq_ISS],
			Site_AX			[Site_AX],
			Status			[Enabled]
		from 
			Site T with(nolock)	
		where
			Nome_Site = @Nome_Site

	End
	
if @Tipo = 'O'
	Begin
		select 
			Cd_Site			[Code],
			Nome_Site		[Site Name],
			Aliq_Pis		[Aliq_Pis],
			Aliq_Cofins		[Aliq_Cofins],
			Aliq_IRRF		[Aliq_IRRF],
			Aliq_CSLL		[Aliq_CSLL],			
			Aliq_ISS		[Aliq_ISS],
			Site_AX			[Site_AX],
			Status			[Enabled]
		from 
			Site T with(nolock)	
		where
			Nome_Site	= @Nome_Site
			and	Status = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Cd_Site			[Code],
			Nome_Site		[Site Name],
			Aliq_Pis		[Aliq_Pis],
			Aliq_Cofins		[Aliq_Cofins],
			Aliq_IRRF		[Aliq_IRRF],
			Aliq_CSLL		[Aliq_CSLL],			
			Aliq_ISS		[Aliq_ISS],
			Site_AX			[Site_AX],
			Status			[Enabled]
		from 
			Site T with(nolock)	
		where
			Nome_Site	= @Nome_Site
			AND Cd_Site <> isnull(@Cd_Site,0)
	End

GO
