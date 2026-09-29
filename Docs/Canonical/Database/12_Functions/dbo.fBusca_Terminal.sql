SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function  dbo.fBusca_Terminal--('IMSSZ201004024')
(
	@Num_Proc	varchar(16)
)

RETURNS varchar(50)

BEGIN

	Declare @Resultado varchar(50)

	IF left(@Num_Proc,2) = 'IM'
		Begin
			SET @Resultado =(select nome_terminal from Terminal where cd_terminal = 
							(select cd_terminal from LLP_Imp_Mar where num_proc_lim=@Num_Proc))
		End

	ELSE IF left(@Num_Proc,2) = 'IO'
		Begin
			SET @Resultado =(select nome_terminal from Terminal where cd_terminal = 
							(select cd_terminal from LLP_Imp_Out where num_proc_lio=@Num_Proc))
		End

	ELSE IF left(@Num_Proc,2) = 'IA'
		Begin
			SET @Resultado =(select nome_terminal from Terminal where cd_terminal = 
							(select cd_terminal from LLP_Imp_Aer where num_proc_lia=@Num_Proc))
		End

	ELSE IF left(@Num_Proc,2) = 'EM'
		Begin
			SET @Resultado =(select nome_terminal from Terminal where cd_terminal = 
							(select cd_terminal from LLP_Exp_Mar where num_proc_lem=@Num_Proc))
		End

	ELSE IF left(@Num_Proc,2) = 'EO'
		Begin
			SET @Resultado =(select nome_terminal from Terminal where cd_terminal = 
							(select cd_terminal from LLP_Exp_Out where num_proc_leo=@Num_Proc))
		End

	IF @Resultado is null
		Begin
			Set @Resultado = (select nome_terminal from Terminal where cd_terminal = 
							 (select campo_dados from campo_processo where id_campo=2 and Num_Proc=
							 (select num_proc_mim from house_imp_mar where num_proc_him=@Num_Proc
								)))
		End

	IF @Resultado is null and len(@Num_Proc) = 14
		Begin
			Set @Resultado = (select nome_terminal from Terminal where cd_terminal = 
							 (select campo_dados from campo_processo where id_campo=2 and Num_Proc=@Num_Proc
							 ))
		End

	IF @Resultado is null and len(@Num_Proc) = 14
		Begin
			Set @Resultado = (select nome_terminal from Terminal where cd_terminal = 
							 (select cd_terminal from Master_Imp_Mar where Num_Proc_MIM=@Num_Proc
							 ))
		End

	IF @Resultado is null and len(@Num_Proc) = 14
		Begin
			Set @Resultado = (select nome_terminal from Terminal where cd_terminal = 
							 (select campo_dados from campo_processo where id_campo=2 and Num_Proc=
							 (select top 1 num_proc_him from house_imp_mar where num_proc_mim=@Num_Proc
								)))
		End

	IF @Resultado is null and len(@Num_Proc) = 14
		Begin
			Set @Resultado = (select nome_terminal from Terminal where cd_terminal = 
							 (select cd_terminal from llp_imp_mar where Num_Proc_LIM=
							 (select top 1 num_proc_him from house_imp_mar where num_proc_mim=@Num_Proc
								)))
		End


	RETURN @Resultado

END


GO
