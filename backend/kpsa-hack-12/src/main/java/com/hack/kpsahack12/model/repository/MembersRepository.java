package com.hack.kpsahack12.model.repository;

import com.hack.kpsahack12.model.entity.member.Members;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MembersRepository extends JpaRepository<Members, Long> {
}