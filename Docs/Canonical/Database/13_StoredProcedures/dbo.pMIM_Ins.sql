SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE pMIM_Ins 
(
@Dt_Emis			varchar(10), 
@Dt_Saida			varchar(10), 
@Dt_Desova			varchar(10),
@Dt_Rcb			varchar(10),
@Dt_Reg_Alf			varchar(10), 
@Reg_Alf			varchar(10), 
@CIMC				varchar(12), 
@MAWB			varchar(25), 
@Sub_Master			varchar(25), 
@Sub_Master_Col		varchar(25), 
@Cd_Consig			varchar(10), 
@Cd_Export			varchar(10), 
@Cd_Org			varchar(3), 
@Cd_Dst			varchar(3), 
@Cd_Armador			varchar(3), 
@Cd_Armador_SM  		varchar(3), 
@Cd_Transb			varchar(3), 
@Navio_Transb			varchar(15), 
@ID_Viagem			Int, 
@IRIN_MIM			varchar(8), 
@Cod_Rec			varchar(2), 
@Cd_Terminal			varchar(3), 
@Qtd_Tot_Vol			Float,
@Vol_Tot			Float,
@Peso_Bruto			float, 
@Tp_Frete			char(1),
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Frete			float(8), 
@Qtd_HAWB			char(2),
@Ref_Int			varchar(20),
@Nivel_DL			varchar(3), 
@Obs				varchar(2000),
@Navio				VarChar(20)=Null,
@Viagem			VarChar(10)=Null,
@Dt_Atrac			varchar(10)=Null, 
@Dt_Oper 			varchar(10)=Null,
@Cd_Armazem			varchar(3)=Null,
@Dt_Ent_Term			datetime=Null,
@Dt_Lib_Bl			datetime=Null,
@AWB				varchar(30)=Null,
@Dt_Rec_Doc			datetime=Null,
@Dt_Doc_Camb		datetime=Null,
@Num_Proc			VarChar(14)= ''	OUTPUT,
@DtRedest_MIM		datetime=null
)
 AS
		Begin Transaction 
 		Execute pMIM_Referencia_Ins @Cd_Dst, 'IM', @Referencia = @Num_Proc OUTPUT
		Insert Into 
			Master_Imp_Mar
			(Num_Proc_MIM, Dt_Emis_MIM, Dt_Saida_MIM, Dt_Desova_MIM, Dt_Rcb_MIM, 
			Dt_Reg_Alf_MIM, Reg_Alf_MIM, CIMC_MIM, MAWB_MIM, Sub_Master_MIM, Sub_Master_Col_MIM, 
			Cd_Consig_MIM, Cd_Export_MIM, Cd_Org_MIM, Cd_Dst_MIM, Cd_Armador, Cd_Armador_SM, 
			Cd_Transb_MIM, Navio_Transb_MIM, ID_Viagem,  IRIN_MIM, Cod_Rec_MIM,Cd_Terminal, Qtd_Tot_Vol_MIM, 
			Vol_Tot_MIM, Peso_Bruto_MIM, Tp_Frete_MIM, Cd_Tp_Moeda, Vlr_Frete_MIM, Qtd_HAWB_MIM, 
			Ref_Int_MIM, Nivel_DL, Obs_MIM, Navio_MIM, Viagem_MIM, Dt_Atrac_MIM, Dt_Oper_MIM, Cd_Armazem, 
			Dt_Ent_Term, Dt_Lib_Bl, AWB, Dt_Rec_Doc, Dt_Doc_Camb,DtRedest_MIM)
		Values
			(@Num_Proc, @Dt_Emis, @Dt_Saida, @Dt_Desova, @Dt_Rcb, @Dt_Reg_Alf, 
			@Reg_Alf, @CIMC, @MAWB, @Sub_Master, @Sub_Master_Col, @Cd_Consig, @Cd_Export, @Cd_Org, 
			@Cd_Dst, @Cd_Armador, @Cd_Armador_SM, @Cd_Transb, @Navio_Transb, @ID_Viagem,@IRIN_MIM, 
			@Cod_Rec, @Cd_Terminal, @Qtd_Tot_Vol, @Vol_Tot, @Peso_Bruto, @Tp_Frete, 
			@Cd_Tp_Moeda, @Vlr_Frete, @Qtd_HAWB, @Ref_Int, @Nivel_DL, @Obs, @Navio, @Viagem, @Dt_Atrac, @Dt_Oper, @Cd_Armazem, 
			@Dt_Ent_Term, @Dt_Lib_Bl, @AWB, @Dt_Rec_Doc, @Dt_Doc_Camb, @DtRedest_MIM)
		If @@RowCount <> 1 
			Begin 
				RollBack Transaction 
				Return - 2
			End 
		Else
			Begin 
				Commit Transaction 
				Return 1 
			End
GO
