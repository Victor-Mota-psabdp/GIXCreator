SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_Busca_Descr_Sel] 'erbson','01','1'
CREATE procedure [dbo].[spATL_Busca_Descr_Sel]
(
	@cd_usuario		varchar(6),
	@strCd_Tela		varchar(6),
	@intID			int
)
as

declare @cd_idioma as varchar(3)
set @cd_idioma = (select Cd_Idioma from usuario with(nolock) where ck_ativo='1' 
					and cd_usuario = @cd_usuario)

select 
	@cd_idioma Idioma, 
	Descr_PTG,
	Descr_ESP,
	Descr_ING 
from ATL_Labels AL with(nolock) 
	join Tela_Labels TL with(nolock) on ID_ATL_Labels = AL.ID 
where 
	cd_tela = @strCd_Tela 
	and lblATL = @intID	
option(hash join)
GO
