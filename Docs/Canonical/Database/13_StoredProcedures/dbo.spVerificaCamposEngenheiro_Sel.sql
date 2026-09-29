SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spVerificaCamposEngenheiro_Sel 'IMHEX201601007BR'
CREATE procedure [dbo].[spVerificaCamposEngenheiro_Sel](
@Num_Proc as varchar(16)
)
as
Declare @DescrCampo Table(
	Descr_Campo varchar(50)
)
SET NOCOUNT ON
if exists(select cd_tp_carga from LLP_imp_mar where cd_tp_carga = 3 and num_proc_lim =@Num_Proc )
	Begin
		--select TCC.Descr_Campo from Campo_Processo CP with(nolock)
		--left join Tipo_Campo_Cliente TCC with(nolock) on CP.Id_Campo = TCC.Id_Campo
		--where num_proc = @Num_Proc and CP.Id_Campo in ('168') and (Campo_Dados ='' or Campo_Dados is null)
		
		if not exists(select Id_Campo from  Campo_processo cp with(nolock) where  Id_Campo in ('168') and  num_proc = @Num_Proc) 
		begin
			insert @DescrCampo
			select top 1 Descr_Campo from Tipo_Campo_Cliente where Id_Campo ='168'
		End
		

		if not exists(select Id_Campo from  Campo_processo cp with(nolock) where  Id_Campo in ('169') and  num_proc = @Num_Proc) 
		begin
			insert @DescrCampo
			select top 1 Descr_Campo from Tipo_Campo_Cliente where Id_Campo = '169'
		End

-- ticket 100-378782 - Trava no ATL para processo de BULK 

        delete from @DescrCampo	

	End
	select * from @DescrCampo
--select num_proc,TCC.Descr_Campo from Campo_Processo CP with(nolock)
--join Tipo_Campo_Cliente TCC with(nolock) on CP.Id_Campo = TCC.Id_Campo
--where CP.Id_Campo in ('168','169')and (Campo_Dados ='' or Campo_Dados is null)




GO
