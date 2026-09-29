SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Cta_Ctb
CREATE procedure [dbo].[spATL_Cta_Ctb_Sel](
	@Cd_Cta_Ctb			varchar(13),
	@Nome_Cta_Ctb		varchar(60),
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

if @Tipo = 'A' 
	Begin
		select
			Cd_Cta_Ctb			[Code],			
			Nome_Cta_Ctb		[Account Name],
			Cd_Cta_Ctb_Red		[Short Code],
			Nome_Cta_Ctb_Red	[Short Account Name],
			Ref_Ctb,
			Ck_Lanc				[Entry],
			Ck_CM,
			Ck_Red,
			Ck_CC				[Cost Center],
			Ck_Conv,
			Ck_Conc,
			Ck_Ativo			[Enable],
			Ck_Plano_06,
			cd_FluxodeCaixa
		from 
			Cta_Ctb with(nolock)
	End
	
if  @Tipo = 'B'
	Begin
		select
			Cd_Cta_Ctb			[Code],			
			Nome_Cta_Ctb		[Account Name],
			Cd_Cta_Ctb_Red		[Short Code],
			Nome_Cta_Ctb_Red	[Short Account Name],
			Ref_Ctb,
			Ck_Lanc				[Entry],
			Ck_CM,
			Ck_Red,
			Ck_CC				[Cost Center],
			Ck_Conv,
			Ck_Conc,
			Ck_Ativo			[Enable],
			Ck_Plano_06,
			cd_FluxodeCaixa
		from 
			Cta_Ctb with(nolock)
		where Ck_Ativo  = 'S'
	End

if @Tipo = 'C' 
	Begin
		select
			Cd_Cta_Ctb			[Code],			
			Nome_Cta_Ctb		[Account Name],
			Cd_Cta_Ctb_Red		[Short Code],
			Nome_Cta_Ctb_Red	[Short Account Name],
			Ref_Ctb,
			Ck_Lanc				[Entry],
			Ck_CM,
			Ck_Red,
			Ck_CC				[Cost Center],
			Ck_Conv,
			Ck_Conc,
			Ck_Ativo			[Enable],
			Ck_Plano_06,
			cd_FluxodeCaixa
		from 
			Cta_Ctb with(nolock)
		where 
			Cd_Cta_Ctb = @Cd_Cta_Ctb
	End
	
if @Tipo = 'D'
	Begin
		select
			Cd_Cta_Ctb			[Code],			
			Nome_Cta_Ctb		[Account Name],
			Cd_Cta_Ctb_Red		[Short Code],
			Nome_Cta_Ctb_Red	[Short Account Name],
			Ref_Ctb,
			Ck_Lanc				[Entry],
			Ck_CM,
			Ck_Red,
			Ck_CC				[Cost Center],
			Ck_Conv,
			Ck_Conc,
			Ck_Ativo			[Enable],
			Ck_Plano_06,
			cd_FluxodeCaixa
		from 
			Cta_Ctb with(nolock)
		where Ck_Ativo  = 'S' and 
			Cd_Cta_Ctb = @Cd_Cta_Ctb
	End
	
if @Tipo = 'N' 
	Begin
		select
			Cd_Cta_Ctb			[Code],			
			Nome_Cta_Ctb		[Account Name],
			Cd_Cta_Ctb_Red		[Short Code],
			Nome_Cta_Ctb_Red	[Short Account Name],
			Ref_Ctb,
			Ck_Lanc				[Entry],
			Ck_CM,
			Ck_Red,
			Ck_CC				[Cost Center],
			Ck_Conv,
			Ck_Conc,
			Ck_Ativo			[Enable],
			Ck_Plano_06,
			cd_FluxodeCaixa
		from 
			Cta_Ctb with(nolock)
		where 
			Nome_Cta_Ctb = @Nome_Cta_Ctb
	End
	
if @Tipo = 'O'
	Begin
		select
			Cd_Cta_Ctb			[Code],			
			Nome_Cta_Ctb		[Account Name],
			Cd_Cta_Ctb_Red		[Short Code],
			Nome_Cta_Ctb_Red	[Short Account Name],
			Ref_Ctb,
			Ck_Lanc				[Entry],
			Ck_CM,
			Ck_Red,
			Ck_CC				[Cost Center],
			Ck_Conv,
			Ck_Conc,
			Ck_Ativo			[Enable],
			Ck_Plano_06,
			cd_FluxodeCaixa
		from 
			Cta_Ctb with(nolock)
		where Ck_Ativo  = 'S' and
			
			Nome_Cta_Ctb = @Nome_Cta_Ctb
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select
			Cd_Cta_Ctb			[Code],			
			Nome_Cta_Ctb		[Account Name],
			Cd_Cta_Ctb_Red		[Short Code],
			Nome_Cta_Ctb_Red	[Short Account Name],
			Ref_Ctb,
			Ck_Lanc				[Entry],
			Ck_CM,
			Ck_Red,
			Ck_CC				[Cost Center],
			Ck_Conv,
			Ck_Conc,
			Ck_Ativo			[Enable],
			Ck_Plano_06,
			cd_FluxodeCaixa
		from 
			Cta_Ctb with(nolock)
		where 
			Nome_Cta_Ctb = @Nome_Cta_Ctb
			AND Cd_Cta_Ctb <> @Cd_Cta_Ctb
	End

GO
