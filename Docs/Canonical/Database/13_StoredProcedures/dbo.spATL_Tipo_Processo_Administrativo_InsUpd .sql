SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Processo_Administrativo

CREATE procedure [dbo].[spATL_Tipo_Processo_Administrativo_InsUpd ]
( 
	@Id_Tp_Proc_Adm BigInt,
    @Nome_Tp_Proc_Adm varchar(MAX),
    --@Nome_Usuario varchar(30),
    @Cd_Usuario as varchar(6),
    @Ativo bit,
    @Dt_Ins datetime
 )
    
AS

	--Declare @Cd_Usuario as varchar(6)	
	--Set @Cd_Usuario = (select Cd_Usuario from usuario where Nome_Usuario = @Nome_Usuario)
	
	if not exists (select Id_Tp_Proc_Adm from Tipo_Processo_Administrativo where Id_Tp_Proc_Adm = @Id_Tp_Proc_Adm)
		Begin			
			Insert into
				Tipo_Processo_Administrativo
				(Nome_Tp_Proc_Adm, Dt_Ins, Cd_Usuario, Ativo
				 )
			values
				(@Nome_Tp_Proc_Adm,GETDATE(),@Cd_Usuario,@Ativo
				)
		End
	Else
	    Begin		
			Update
				Tipo_Processo_Administrativo
			Set				        
		        Nome_Tp_Proc_Adm = @Nome_Tp_Proc_Adm,
				Dt_Ins = GETDATE(),
				Cd_Usuario = @Cd_Usuario,
				Ativo =@Ativo
			Where
				Id_Tp_Proc_Adm = @Id_Tp_Proc_Adm
				
		End

GO
