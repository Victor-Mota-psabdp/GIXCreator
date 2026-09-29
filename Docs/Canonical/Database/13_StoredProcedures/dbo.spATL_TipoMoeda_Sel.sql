SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_TipoMoeda_Sel]
(
	@Cd_Tp_Moeda as varchar(3),
	@Nome_Tp_Moeda as Varchar(30),
	@Tipo as char
)
as
if @Tipo = 'A'
	Begin
		if @Cd_Tp_Moeda = '' or @Cd_Tp_Moeda is null
		Begin
			select (Case When Cd_Tp_Moeda = 'REL' then 'BRL' else Cd_Tp_Moeda End) Cd_Tp_Moeda, Nome_Tp_Moeda from Tipo_Moeda
			where Nome_Tp_Moeda = @Nome_Tp_Moeda
		End
		else
		Begin
			if @Cd_Tp_Moeda = 'BRL'
				set @Cd_Tp_Moeda = 'REL'
				
			select (Case When Cd_Tp_Moeda = 'REL' then 'BRL' else Cd_Tp_Moeda End) Cd_Tp_Moeda, Nome_Tp_Moeda from Tipo_Moeda
			where  Cd_Tp_Moeda = @Cd_Tp_Moeda
		End
	End
if @Tipo = 'B'
	Begin
		if @Cd_Tp_Moeda = '' or @Cd_Tp_Moeda is null
			Begin
				select (Case When Cd_Tp_Moeda = 'REL' then 'BRL' else Cd_Tp_Moeda End) Cd_Tp_Moeda, Nome_Tp_Moeda from Tipo_Moeda
				where Nome_Tp_Moeda = @Nome_Tp_Moeda and Ativo = 1
			End
		else
			Begin
				if @Cd_Tp_Moeda = 'BRL'
					set @Cd_Tp_Moeda = 'REL'
					
				select (Case When Cd_Tp_Moeda = 'REL' then 'BRL' else Cd_Tp_Moeda End) Cd_Tp_Moeda, Nome_Tp_Moeda from Tipo_Moeda
				where  Cd_Tp_Moeda = @Cd_Tp_Moeda and Ativo = 1	
			End
	End
GO
